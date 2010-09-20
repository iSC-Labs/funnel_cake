# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{funnel_cake}
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Joshua Krall"]
  s.date = %q{2010-09-19}
  s.email = %q{joshuakrall@pobox.com}
  s.executables = ["autospec", "b2json", "edit_json.rb", "erubis", "htmldiff", "j2bson", "jeweler", "ldiff", "mmconsole", "prettify_json.rb", "rackup", "rails", "rake", "rake2thor", "rspec", "rubyforge", "thor", "tt"]
  s.extra_rdoc_files = [
    "README.markdown"
  ]
  s.files = [
    "app/controllers/analytics/common_controller.rb",
     "app/controllers/analytics/conversions_controller.rb",
     "app/controllers/analytics/dashboards_controller.rb",
     "app/controllers/analytics/events_controller.rb",
     "app/controllers/analytics/ignores_controller.rb",
     "app/controllers/analytics/states_controller.rb",
     "app/controllers/analytics/stats_controller.rb",
     "app/controllers/analytics/visitors_controller.rb",
     "app/helpers/analytics/common_helper.rb",
     "app/helpers/analytics/conversions_helper.rb",
     "app/helpers/analytics/dashboards_helper.rb",
     "app/helpers/analytics/events_helper.rb",
     "app/helpers/analytics/states_helper.rb",
     "app/helpers/analytics/stats_helper.rb",
     "app/models/analytics/event.rb",
     "app/models/analytics/ignore.rb",
     "app/models/analytics/visitor.rb",
     "app/views/analytics/common/_daterange_label.html.erb",
     "app/views/analytics/common/_filter_fields_input.html.erb",
     "app/views/analytics/common/_filter_fields_update.js.erb",
     "app/views/analytics/common/_grab_filter_fields.js.erb",
     "app/views/analytics/common/_stats_update.js.erb",
     "app/views/analytics/common/_visitors_update.js.erb",
     "app/views/analytics/conversions/_conversion.html.erb",
     "app/views/analytics/conversions/_detail.html.erb",
     "app/views/analytics/conversions/_graph.html.erb",
     "app/views/analytics/conversions/compare.html.erb",
     "app/views/analytics/conversions/graph_table_data.js.rjs",
     "app/views/analytics/conversions/index.html.erb",
     "app/views/analytics/conversions/show.html.erb",
     "app/views/analytics/conversions/stats.js.rjs",
     "app/views/analytics/dashboards/_diagram.html.erb",
     "app/views/analytics/dashboards/overview.html.erb",
     "app/views/analytics/events/_event.html.erb",
     "app/views/analytics/events/index.html.erb",
     "app/views/analytics/events/show.html.erb",
     "app/views/analytics/ignores/edit.html.erb",
     "app/views/analytics/ignores/index.html.erb",
     "app/views/analytics/ignores/new.html.erb",
     "app/views/analytics/ignores/show.html.erb",
     "app/views/analytics/states/_state_stat_table.html.erb",
     "app/views/analytics/states/_visitors_table.html.erb",
     "app/views/analytics/states/index.html.erb",
     "app/views/analytics/states/show.html.erb",
     "app/views/analytics/stats/_global_stat_table.html.erb",
     "app/views/analytics/stats/_stat.html.erb",
     "app/views/analytics/stats/_stat_internals.html.erb",
     "app/views/analytics/stats/index.html.erb",
     "app/views/analytics/stats/show.html.erb",
     "app/views/analytics/stats/show.js.rjs",
     "app/views/analytics/visitors/edit.html.erb",
     "app/views/analytics/visitors/index.html.erb",
     "app/views/analytics/visitors/new.html.erb",
     "app/views/analytics/visitors/show.html.erb",
     "config/routes.rb",
     "doc/example_funnel.png",
     "lib/funnel_cake.rb",
     "lib/funnel_cake/acts_as_funnel_state_machine.rb",
     "lib/funnel_cake/data_hash.rb",
     "lib/funnel_cake/data_store/mongo_mapper/engine.rb",
     "lib/funnel_cake/data_store/mongo_mapper/event.rb",
     "lib/funnel_cake/data_store/mongo_mapper/ignore.rb",
     "lib/funnel_cake/data_store/mongo_mapper/visitor.rb",
     "lib/funnel_cake/engine.rb",
     "lib/funnel_cake/has_funnel/user_extensions.rb",
     "lib/funnel_cake/has_visitor_tracking/controller_extensions.rb",
     "lib/funnel_cake/rails_engine.rb",
     "lib/funnel_cake/random_id.rb",
     "lib/funnel_cake/state_period_helpers.rb",
     "public/images/ajax-loader.gif",
     "public/javascripts/canviz.js",
     "public/javascripts/excanvas.js",
     "public/javascripts/flotr-0.2.0-alpha.js",
     "public/javascripts/flotr.debug-0.2.0-alpha.js",
     "public/javascripts/funnelcake.js",
     "public/javascripts/path.js",
     "public/javascripts/x11colors.js",
     "public/stylesheets/funnel_cake.css",
     "public/test.dot",
     "public/test.xdot",
     "tasks/_diagram.dot.erb",
     "tasks/funnel_cake_tasks.rake"
  ]
  s.homepage = %q{http://github.com/jkrall/funnel_cake}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{Analytics engine for Rails 3}
  s.test_files = [
    "spec/factories/event.rb",
     "spec/factories/ignore.rb",
     "spec/factories/visitor.rb",
     "spec/funnel_cake/data_store/mongo_mapper/engine_spec.rb",
     "spec/funnel_cake_spec.rb",
     "spec/spec_helper.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<mongo_mapper>, [">= 0"])
      s.add_runtime_dependency(%q<bson_ext>, [">= 0"])
      s.add_runtime_dependency(%q<diff-lcs>, [">= 0"])
      s.add_runtime_dependency(%q<fastercsv>, [">= 0"])
    else
      s.add_dependency(%q<mongo_mapper>, [">= 0"])
      s.add_dependency(%q<bson_ext>, [">= 0"])
      s.add_dependency(%q<diff-lcs>, [">= 0"])
      s.add_dependency(%q<fastercsv>, [">= 0"])
    end
  else
    s.add_dependency(%q<mongo_mapper>, [">= 0"])
    s.add_dependency(%q<bson_ext>, [">= 0"])
    s.add_dependency(%q<diff-lcs>, [">= 0"])
    s.add_dependency(%q<fastercsv>, [">= 0"])
  end
end
