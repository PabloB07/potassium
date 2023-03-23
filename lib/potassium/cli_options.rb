module Potassium::CliOptions # rubocop:disable Metrics/ModuleLength
  CREATE_OPTIONS = [
    {
      type: :switch,
      name: 'version-check',
      desc: 'Performs a version check before running.',
      negatable: true,
      default_value: true,
      default_test_value: true
    },
    {
      type: :switch,
      name: 'node-version-check',
      desc: 'Performs a node version check before running.',
      negatable: true,
      default_value: true,
      default_test_value: true
    },
    {
      type: :flag,
      name: [:db, :database],
      desc: "Decides which database to use. Available: mysql, postgresql, none",
      default_test_value: "postgresql"
    },
    {
      type: :flag,
      name: "locale",
      desc: "Decides which locale to use. Available: es-CL, en",
      default_test_value: "es-CL"
    },
    {
      type: :flag,
      name: [:email_service, :email],
      desc: "Decides which email adapter to use. Available: aws_ses, sendgrid, none",
      default_test_value: "None"
    },
    {
      type: :switch,
      name: "devise",
      desc: "Whether to use Devise for authentication or not",
      negatable: true,
      default_value: "none",
      default_test_value: false
    },
    {
      type: :switch,
      name: "devise-user-model",
      desc: "Whether to create a User model for Devise",
      negatable: true,
      default_value: "none",
      default_test_value: false
    },
    {
      type: :switch,
      name: "admin",
      desc: "Whether to use ActiveAdmin or not",
      negatable: true,
      default_value: "none",
      default_test_value: false
    },
    {
      type: :switch,
      name: :vue_admin,
      desc: "Whether to use Vue within ActiveAdmin or not",
      negatable: true,
      default_value: "none",
      default_test_value: false
    },
    {
      type: :switch,
      name: "pundit",
      desc: "Whether to use Pundit for authorization or not",
      negatable: true,
      default_value: "none",
      default_test_value: false
    },
    {
      type: :switch,
      name: "api",
      desc: "Whether to include power_api for API support or not",
      default_value: "none",
      default_test_value: false
    },
    {
      type: :flag,
      name: "storage",
      desc: "Decides which file storage to use. Available: active_storage, shrine, none",
      default_value: "none",
      default_test_value: "None"
    },
    {
      type: :switch,
      name: "heroku",
      desc: "Whether to prepare to application for Heroku or not",
      negatable: true,
      default_value: "none",
      default_test_value: false
    },
    {
      type: :switch,
      name: "background_processor",
      desc: "Whether to use Sidekiq for background processing or not",
      default_test_value: false
    },
    {
      type: :switch,
      name: "draper",
      desc: "Whether to use Draper or not",
      negatable: true,
      default_value: "none",
      default_test_value: false
    },
    {
      type: :switch,
      name: "github",
      desc: "Whether to create a github repository",
      negatable: true,
      default_value: "none",
      default_test_value: false
    },
    {
      type: :switch,
      name: "github_private",
      desc: "Whether the github repository is private or not",
      negatable: true,
      default_value: "none",
      default_test_value: false
    },
    {
      type: :switch,
      name: "github_has_org",
      desc: "Whether the github repository should belong to an organization",
      negatable: true,
      default_value: "none",
      default_test_value: false
    },
    {
      type: :flag,
      name: "github_org",
      desc: "The github organization where the repository will be created",
      default_value: "none",
      default_test_value: "none"
    },
    {
      type: :flag,
      name: "github_name",
      desc: "The github repository name",
      default_value: "none",
      default_test_value: "none"
    },
    {
      type: :flag,
      name: "github_access_token",
      desc: "Github personal access token used to auth to Github API",
      default_value: "none",
      default_test_value: "none"
    },
    {
      type: :switch,
      name: "schedule",
      desc: "Whether to use sidekiq-scheduler as job scheduler",
      negatable: true,
      default_value: "none",
      default_test_value: false
    },
    {
      type: :switch,
      name: "sentry",
      desc: "Whether to use Sentry as error reporting tool",
      negatable: true,
      default_value: "none",
      default_test_value: false
    },
    {
      type: :switch,
      name: :front_end_vite,
      desc: "Whether to use Vite as frontend bundler",
      negatable: true,
      default_value: true,
      default_test_value: true
    },
    {
      type: :switch,
      name: 'google_tag_manager',
      desc: 'Whether to use google tag manager',
      negatable: true,
      default_value: 'none',
      default_test_value: false
    },
    {
      type: :switch,
      name: "test",
      desc: "Whether or not it is a test project creation",
      negatable: true,
      default_value: false,
      default_test_value: true
    },
    {
      type: :switch,
      name: "spring",
      desc: "Whether to use Spring",
      negatable: true,
      default_value: true,
      default_test_value: false
    },
    {
      type: :switch,
      name: 'platanus-config',
      desc: 'Wheter to use the Platanus configuration.',
      negatable: true,
      default_value: false,
      default_test_value: false
    }
  ]

  def create_options(test_env = false)
    CREATE_OPTIONS.map do |opts|
      opts = opts.dup
      test_default_value = opts.delete(:default_test_value)
      opts[:default_value] = test_default_value if test_env
      opts
    end
  end

  def create_arguments(test_env = false)
    create_options(test_env).inject({}) do |memo, opts|
      opt = opts[:name].is_a?(Array) ? opts[:name].first : opts[:name]
      memo[opt.to_s] = opts[:default_value]
      memo
    end
  end

  def self.option_names
    CREATE_OPTIONS.map { |option| option[:name] }.flatten.map(&:to_sym)
  end
end
