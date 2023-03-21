class Recipes::GoogleTagManager < Rails::AppBuilder
  def ask
    use_google_tag_manager = answer(:google_tag_manager) do
      Ask.confirm 'Do you want to use Google Tag Manager?'
    end

    set(:google_tag_manager, use_google_tag_manager)
  end

  def create
    install if selected?(:google_tag_manager)
  end

  def install
    add_google_tag_manager
  end

  def add_google_tag_manager
    copy_tag_manager_files
    append_to_file '.env.development', "GTM_CONTAINER_ID=\n"
    include_tag_manager
    add_content_security_policy
  end

  def add_content_security_policy
    inject_into_file(
      'config/initializers/content_security_policy.rb',
      content_security_policy_code,
      before: '# Report violations without enforcing the policy.'
    )
  end

  def copy_tag_manager_files
    copy_file(
      '../assets/app/views/shared/_gtm_head.html.erb',
      'app/views/shared/_gtm_head.html.erb',
      force: true
    )

    copy_file(
      '../assets/app/views/shared/_gtm_body.html.erb',
      'app/views/shared/_gtm_body.html.erb',
      force: true
    )
  end

  def include_tag_manager
    inject_into_file(
      'app/views/layouts/application.html.erb',
      render_string('shared/gtm_head'),
      before: '</head>'
    )

    inject_into_file(
      'app/views/layouts/application.html.erb',
      render_string('shared/gtm_body'),
      after: '<body>'
    )
  end

  private

  def render_string(file_path)
    "  <%if Rails.env.production? %>
      <%= render \"#{file_path}\" %>
    <% end %>\n  "
  end

  def content_security_policy_code
    <<~HERE
      # policy.connect_src(
      #   *policy.connect_src,
      #   'https://www.google-analytics.com'
      # )
      # google tag manager requires to enable unsafe inline:
      # https://developers.google.com/tag-manager/web/csp
      # policy.script_src(
      #   *policy.script_src,
      #   'https://www.googletagmanager.com',
      #   'https://www.google-analytics.com',
      #   'https://ssl.google-analytics.com'
      # )
      # policy.img_src(
      #   *policy.img_src,
      #   'https://www.googletagmanager.com',
      #   'https://www.google-analytics.com'
      # )
    HERE
  end
end
