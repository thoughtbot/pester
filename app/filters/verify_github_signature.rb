class VerifyGithubSignature
  def initialize(github_secret)
    @github_secret = github_secret
  end

  def before(controller)
    unless github_signature_matches?(controller.request)
      controller.render nothing: true, status: :unauthorized
    end
  end

  protected

  attr_reader :github_secret

  private

  def github_signature_matches?(request)
    github_signature(request) == expected_signature(request)
  end

  def github_signature(request)
    request.env["HTTP_X_HUB_SIGNATURE"]
  end

  def expected_signature(request)
    "sha1=" + hexdigest(request)
  end

  def hexdigest(request)
    OpenSSL::HMAC.hexdigest(hmac_digest, github_secret, raw_post_data(request))
  end

  def raw_post_data(request)
    request.env["RAW_POST_DATA"] || ""
  end

  def hmac_digest
    OpenSSL::Digest.new("sha1")
  end
end
