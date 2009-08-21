module FunnelCake
  class Engine

    # Accessor and default for User class
    @@user_class_name = 'User'
    cattr_accessor :user_class_name
    def self.user_class
      @@user_class_name.constantize
    end

    # Accessor and default for Analytics::Visitor class
    @@visitor_class_name = 'Analytics::Visitor'
    cattr_accessor :visitor_class_name
    def self.visitor_class
      @@visitor_class_name.constantize
    end

    # Accessor and default for Analytics::Event class
    @@event_class_name = 'Analytics::Event'
    cattr_accessor :event_class_name
    def self.event_class
      @@event_class_name.constantize
    end

    # Method for finding users/visitors who are "eligible" for
    # transitioning from a given state, for a given time period
    # (Used in calculating conversion rates)
    # We qualify users who:
    # - entered the given state before the end of the date range (but within the attrition timeframe)
    # MINUS
    # - exited the given state before the beginning of the date range
    def self.find_by_starting_state(state, opts={})
      return [] if state.nil?
      state = state.to_sym
      return [] unless Analytics::Visitor.states.include?(state)

      date_range = opts[:date_range]
      attrition_period = opts[:attrition_period]
      attrition_period = Analytics::Visitor.state_options(state)[:attrition_period] unless Analytics::Visitor.state_options(state)[:attrition_period].nil?
      unless attrition_period.nil?
        attrition_period = (date_range.end - date_range.begin)*2.0 if attrition_period > ((date_range.end - date_range.begin)*2.0)
      end

      condition_frags = []
      condition_frags << "#{event_class.table_name}.to = '#{state}'"
      condition_frags << "#{event_class.table_name}.created_at < '#{date_range.end.to_s(:db)}'" unless date_range.nil?
      condition_frags << "#{event_class.table_name}.created_at > '#{(date_range.end - attrition_period).to_s(:db)}'" unless (date_range.nil? or attrition_period.nil?)
      condition_frags << opts[:conditions] unless opts[:conditions].nil?
      entering_a_user_visitors = Analytics::Visitor.find(:all, :joins=>[:events], :conditions=>condition_frags.join(" AND "))

      condition_frags = []
      condition_frags << "#{event_class.table_name}.from = '#{state}'"
      condition_frags << "#{event_class.table_name}.created_at < '#{date_range.begin.to_s(:db)}'" unless date_range.nil?
      condition_frags << opts[:conditions] unless opts[:conditions].nil?
      leaving_a_user_visitors = Analytics::Visitor.find(:all, :joins=>[:events], :conditions=>condition_frags.join(" AND "))

      all = (entering_a_user_visitors - leaving_a_user_visitors).uniq
      filter_visitors(all, opts)
    end


    # Method for finding users/visitors who transitioned
    # into a given state, for a given time period
    # (Used in calculating conversion rates)
    # We qualify users who:
    # - entered the given state during the date range
    def self.find_by_ending_state(state, opts={})
      return [] if state.nil?
      state = state.to_sym
      return [] unless Analytics::Visitor.states.include?(state)

      date_range = opts[:date_range]

      condition_frags = []
      condition_frags << "#{event_class.table_name}.to = '#{state}'"
      condition_frags << "#{event_class.table_name}.created_at >= '#{date_range.begin.to_s(:db)}'" unless date_range.nil?
      condition_frags << "#{event_class.table_name}.created_at <= '#{date_range.end.to_s(:db)}'" unless date_range.nil?
      condition_frags << opts[:conditions] unless opts[:conditions].nil?
      leaving_a_user_visitors = Analytics::Visitor.find(:all, :joins=>[:events], :conditions=>condition_frags.join(" AND "))

      filter_visitors(leaving_a_user_visitors.uniq, opts)
    end

    # Method for finding users/visitors who transitioned
    # into a given state, from a given state, for a given time period
    # (Used in calculating conversion rates)
    # We qualify users who:
    # - exited the start state during the date range
    # AND
    # - entered the end state during the date range
    def self.find_by_state_pair(start_state, end_state, opts={})
      return [] if start_state.nil? or end_state.nil?
      start_state = start_state.to_sym
      end_state = end_state.to_sym
      return [] unless Analytics::Visitor.states.include?(start_state)
      return [] unless Analytics::Visitor.states.include?(end_state)

      date_range = opts[:date_range]

      condition_frags = []
      condition_frags << "#{event_class.table_name}.from = '#{start_state}'"
      condition_frags << "#{event_class.table_name}.created_at >= '#{date_range.begin.to_s(:db)}'" unless date_range.nil?
      condition_frags << "#{event_class.table_name}.created_at <= '#{date_range.end.to_s(:db)}'" unless date_range.nil?
      condition_frags << opts[:conditions] unless opts[:conditions].nil?
      leaving_a_user_visitors = Analytics::Visitor.find(:all, :joins=>[:events], :conditions=>condition_frags.join(" AND "))

      entering_b_user_visitors = find_by_ending_state(end_state, opts)

      all = leaving_a_user_visitors & entering_b_user_visitors
      filter_visitors(all, opts)
    end


    # Method for finding users who transitioned
    # into a given state, from a given state, WITH NO STATES INBETWEEN,
    # for a given time period
    # We qualify users who:
    # - exited the start state during the date range
    # AND
    # - entered the end state during the date range
    def self.find_by_transition(start_state, end_state, opts={})
      return [] if start_state.nil? or end_state.nil?
      start_state = start_state.to_sym
      end_state = end_state.to_sym
      return [] unless Analytics::Visitor.states.include?(start_state)
      return [] unless Analytics::Visitor.states.include?(end_state)

      date_range = opts[:date_range]

      condition_frags = []
      condition_frags << "#{event_class.table_name}.from = '#{start_state}'"
      condition_frags << "#{event_class.table_name}.to = '#{end_state}'"
      condition_frags << "#{event_class.table_name}.created_at >= '#{date_range.begin.to_s(:db)}'" unless date_range.nil?
      condition_frags << "#{event_class.table_name}.created_at <= '#{date_range.end.to_s(:db)}'" unless date_range.nil?
      condition_frags << opts[:conditions] unless opts[:conditions].nil?
      user_visitors = Analytics::Visitor.find(:all, :joins=>[:events], :conditions=>condition_frags.join(" AND "))

      filter_visitors(user_visitors.uniq, opts)
    end


    # Calculate conversion rate between two states
    # By calculating the number of users in the end state,
    # divided by the number of users in the start state
    def self.conversion_rate(start_state, end_state, opts={})
      stats = conversion_stats(start_state, end_state, opts)
      return stats[:rate]
    end

    # Calculate conversion rate between two states
    # Returns: number of users in the end state,
    # and number of users in the start state
    def self.conversion_stats(start_state, end_state, opts={})
      Rails.cache.fetch("FC.conversion_stats:#{start_state}-#{end_state}-#{opts.inspect.gsub(/[\s:=>\"\{\}\,]/,'')}", :expires_in=>1.day) do
        if start_state.nil? or end_state.nil?
          {:rate=>0.0, :end_count=>0, :start_count=>0}
        else
          visitors = conversion_visitors(start_state, end_state, opts)
          stats = {}
          stats[:end_count] = visitors[:end].length.to_f
          stats[:start_count] = visitors[:start].length.to_f

          stats[:rate] = 0.0
          stats[:rate] = stats[:end_count] / stats[:start_count] if stats[:start_count] != 0.0
          stats
        end
      end
    end

    # Helper method to return visitors who correspond to conversion rate stats between states
    def self.conversion_visitors(start_state, end_state, opts={})
      if start_state.nil? or end_state.nil?
        {:end=>[], :start=>[]}
      else
        # converted_visitors = self.find_by_state_pair(start_state, end_state, opts)
        converted_visitors = self.find_by_ending_state(end_state, opts)
        starting_state_visitors = self.find_by_starting_state(start_state, opts).to_a | converted_visitors
        visitors = {}
        visitors[:end] = converted_visitors
        visitors[:start] = starting_state_visitors
        visitors
      end
    end

    private

    # Filters Visitors from a list per an options hash
    # For example:
    # :has_event_with=>{ :url=>'/some_url' }
    # :has_event_matching=>{ :url=>'url_match' }
    # or...
    # :first_event_with=>{ :referer=>'/referer_url' }
    # :first_event_matching=>{ :referer=>'referer_match' }
    def self.filter_visitors(visitors, opts={})

      opts[:has_event_with].each do |filter, value|
        visitors.delete_if { |v| v.events.find(:first, :conditions=>["#{filter} = ?", value]).nil? } unless value.blank?
      end if opts[:has_event_with]

      opts[:has_event_matching].each do |filter, value|
        visitors.delete_if { |v| v.events.find(:first, :conditions=>"#{filter} LIKE '%#{value}%'").nil? } unless value.blank?
      end if opts[:has_event_matching]

      opts[:first_event_with].each do |filter, value|
        visitors.delete_if { |v| v.events.first.attributes[filter.to_s] != value } unless value.blank?
      end if opts[:first_event_with]

      opts[:first_event_matching].each do |filter, value|
        visitors.delete_if do |v|
          (v.events.first.attributes[filter.to_s] ? v.events.first.attributes[filter.to_s].match(value) : nil).nil? unless value.blank?
        end
      end if opts[:first_event_matching]

      return visitors
    end

  end
end