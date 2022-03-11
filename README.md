# Potassium [![Circle CI](https://circleci.com/gh/platanus/potassium.svg?style=svg)](https://circleci.com/gh/platanus/potassium)

A Rails application generator from [Platanus](https://github.com/platanus), inspired by [Suspenders](https://github.com/thoughtbot/suspenders).

## Installation

You have to install Potassium globally:

    $ gem install potassium

## Usage

### Starting a new project from scratch

Use the `potassium create` command to create a new project:

    $ potassium create <project-name>

> Please note:
> 1. Potassium will perform a version check before running to ensure that you are using the latest potassium.
> 2. If you feel that it's too slow, you may need to update rubygems: `gem update --system`.
> 3. Potassium uses node under the hood, so a check will also be performed to ensure you are running the supported version.

### Adding recipes to an existing project

Use the `potassium install` command to add a recipe to a project:

    $ potassium install devise

You can force an already installed recipe by passing the `--force` argument

    $ potassium install devise --force

You can run the command on its own to view all the available recipes and select one:

    $ potassium install

## What's inside Potassium?

Potassium Rails apps includes the following gems and technologies:

- [dotenv](https://github.com/bkeepers/dotenv) for loading environmental variables in development
- [Yarn](https://yarnpkg.com) for frontend assets packages
- [EditorConfig](http://editorconfig.org) for keeping all our editor configurations the same
- [pry](http://pryrepl.org) and [pry-byebug](https://github.com/deivid-rodriguez/pry-byebug) for a less painful debugging experience
- [RSpec](http://rspec.info) for unit and integration testing
- [FactoryBot](https://github.com/thoughtbot/factory_bot) for test factories
- [Guard](http://guardgem.org) for continuous testing and other watch-related tasks
- [AWS-SDK](https://github.com/aws/aws-sdk-ruby) for file uploads, sdks, etc and because we use AWS
- [Puma](https://github.com/puma/puma) to serve HTTP requests
- [Rack Timeout](https://github.com/heroku/rack-timeout) to abort requests that are
  taking too long
- [Tzinfo-Data](https://github.com/tzinfo/tzinfo-data) for updating timezone information
- [Faker](https://github.com/stympy/faker) for creating development data
- [Scout](https://github.com/scoutapp/scout_apm_ruby) for monitoring performance

The following optional integrations are also added:

- [PostgreSQL](http://www.postgresql.org) or [MySQL](https://www.mysql.com) for the database
- [Devise](https://github.com/plataformatec/devise) for authentication
- [ActiveAdmin](http://activeadmin.info) for admin interfaces
- [ActiveAdminAddons](https://github.com/platanus/activeadmin_addons) for some help with ActiveAdmin
- [Pundit](https://github.com/elabs/pundit) for role-based authorization
- [Sidekiq](https://github.com/mperham/sidekiq) a simple, efficient background processing for Ruby
- [Sidekiq-scheduler](https://github.com/moove-it/sidekiq-scheduler) to run scheduled processes
- Mailing configuration for [AWS SES](https://github.com/aws/aws-sdk-rails)
  and [Sendgrid](https://github.com/platanus/send_grid_mailer) with recipient interceptor support
- [Sentry](https://sentry.io) to monitor exceptions and errors
- [Vue.js](https://vuejs.org) or [Angular 2](https://angular.io/) for frontend development
- [Google Tag Manager](https://tagmanager.google.com/) for analytics
- Creates the Github repository of your choice for the project. A local git repository will always be created.

A few more things are added to the project:

- A [low database connection pool limit][pool]
- Setup continuous integration in [CircleCI](circle-ci) to run tests
- A `bin/setup` script to setup things on a newly cloned project
- A `bin/cibuild` script to run continuous integration build on CI
- A `db:fake_data:load` rake task to load fake data for development

[pool]: https://devcenter.heroku.com/articles/concurrency-and-database-connections

### API support

The optional API support includes:

- [Responders](https://github.com/plataformatec/responders) for dry-ing our api controllers
- [Versionist](https://github.com/bploetz/versionist) for some flexible api versioning
- [ActiveModel::Serializers](https://github.com/rails-api/active_model_serializers) for record serialization
- [Simple Token Authentication](https://github.com/gonzalo-bulnes/simple_token_authentication) for stateless API authentication

### Heroku

When you choose to deploy to heroku a few extra things are added for the project.

  - Adds a [Procfile][procfile] to define the processes to run in heroku
  - Setup continuous integration using docker and herokuish to maintain better parity between testing and production environments
  - Adds a `bin/release` file with the release phase script to run specific tasks before the app is deployed completely, for example `rails db:migrate:with_data`
  - Adds a `.buildpacks` file with the default buildpacks to use. It use the following buildpacks:

| index | buildpack | description |
|-------|-----------|-------------|
| 1.    | [nodejs][heroku-buildpack-nodejs] | to support javascript package management with `yarn` and `webpack` based asset compiling |
| 2.    | [ruby-version][heroku-buildpack-ruby-version] | to support the use of `.ruby-version` file to instruct heroku which ruby version to use |
| 3.    | [ruby][heroku-buildpack-ruby] | the base buildpack to run ruby applications |

Also the heroku applications are created

  - Creates a `staging` and `production` applications
  - Creates a pipeline and assign the above application to the `staging`
    and `production` stages
  - Setup initial configuration variables
  - Set the application buildpack to the [multi-buildpack][heroku-buildpack-multi]

You'll need to manually

  - Connect the pipeline with the github repository
  - Assign a branch to each stage for auto deployments
  - Enable deploy after CI pass

### Continuous Integration

In order to CicleCI start building the project on each push you need tell circle ci.
Go to https://circleci.com/add-projects, choose the repository from the list and hit
**Build Project**

#### ReviewDog

In order to enable code linting via CircleCI and ReviewDog, you need to activate the **Only build pull requests** option under the `Advanced settings` section for your project.

[heroku-logging]: https://devcenter.heroku.com/articles/logging#writing-to-your-log
[procfile]: https://devcenter.heroku.com/articles/procfile
[heroku-buildpack-ruby-version]: http://github.com/platanus/heroku-buildpack-ruby-version
[heroku-buildpack-nodejs]: https://github.com/heroku/heroku-buildpack-nodejs
[heroku-buildpack-ruby]: http://github.com/heroku/heroku-buildpack-ruby
[heroku-buildpack-multi]: http://github.com/heroku/heroku-buildpack-multi
[circle-ci]: https://circleci.com

## Development Tools

### Creating a new **Test** project from scratch

This is useful when you are adding new recipes to Potassium, and you want to use the `potassium create` command, to check the new functionality without pain.
To achieve this you need to run, **In the Potassium's root path**, the `bin/potassium_test create` instead of `potassium create` command.
This command, will do the same as `potassium create` but first:

- Will drop any existent database of the test app
- Will remove the directory containing a previous version of the test app

It's important to remember that `bin/potassium_test create`:

- Does not receive an `app_path` param. It always creates the test project inside `/tmp/dummy_app`
- Can receive the same options as `potassium create`
- Runs with options with a default value. This is to avoid the "asking part" of the creation process. You need to enable what you want to test like this: `$ bin/potassium_test create --clockwork`

## Publishing
On master branch.

1. Change `VERSION` in `lib/potassium/version.rb`
2. Change `Unreleased` title to current version in `CHANGELOG.md`
3. Commit new release. For example: `Releasing v6.3.0`
4. Create tag. For example: `git tag v6.3.0`
5. Push tag: `git push origin v6.3.0`

## Contributing

If you want to add functionality please go to
the [contributing](/docs/CONTRIBUTING.md)

## Credits

Thank you [contributors](https://github.com/platanus/potassium/graphs/contributors)!

<img src="http://platan.us/gravatar_with_text.png" alt="Platanus" width="250"/>

potassium is maintained by [platanus](http://platan.us).

## License

Potassium is © 2014 Platanus, SPA. It is free software and may be redistributed under the terms specified in the [LICENSE](/LICENSE.txt) file.
