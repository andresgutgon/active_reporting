# frozen_string_literal: true

require 'rails/generators/active_record'

module ActiveReporting
  class MysqlFunctionMigrationGenerator < ActiveRecord::Generators::Base
    argument :name, type: :string, default: 'no_name', banner: 'This migration has default name'
    source_root File.expand_path("../templates", __FILE__)

    def copy_active_reporting_migration
      if mysql? && !migration_exists?
        migration_template(
          'migration.rb',
          "#{migration_path}/add_date_trunc_function_to_mysql.rb",
          migration_version: migration_version
        )
      end
    end

    def migration_exists?
      Dir.glob(
        "#{File.join(destination_root, migration_path)}/[0-9]*_*.rb"
      ).grep(/\d+_add_date_trunc_function_to_mysql.rb$/).present?
    end

    def rails5_and_up?
      Rails::VERSION::MAJOR >= 5
    end

    def mysql?
      config = ActiveRecord::Base.configurations[Rails.env]
      config && config['adapter'] == 'mysql2'
    end

    def migration_version
      if rails5_and_up?
        "[#{Rails::VERSION::MAJOR}.#{Rails::VERSION::MINOR}]"
      end
    end

    def migration_path
      if Rails.version >= '5.0.3'
        db_migrate_path
      else
        @migration_path ||= File.join('db', 'migrate')
      end
    end
  end
end
