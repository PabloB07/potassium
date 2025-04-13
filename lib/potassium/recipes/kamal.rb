class Recipes::Kamal < Rails::AppBuilder
  def ask
    use_kamal = answer(:kamal) do
      Ask.confirm("Do you want to use Kamal 2.0 for deployment?")
    end
    set(:use_kamal, true) if use_kamal
    @app_name = ask("What's your application name for deployment?")
    @app_domain = ask("What's your application domain for deployment?")
    @server_ip = ask("What's your server IP address for Kamal?")
    @registry = ask("What's your Docker registry URL (Image name)?")
  end

  def create
    if get(:use_kamal)
      gather_gem('kamal', '~> 2.5.3')
      template "config/deploy.yml.erb", "config/deploy.yml"
    end
  end

  def install
    if gem_exists?(/kamal/)
      info "Kamal is already installed"
    else
      install_kamal
    end
  end

  private

  def install_kamal
    gather_gem('kamal', '~> 2.0')
    after(:gem_install) do
      run "bundle exec kamal setup"
    end
  end
end 