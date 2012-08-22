require "spec_helper"

describe "app" do
  it "redirects to the index file" do
    get "/"
    last_response.headers["Location"].should match(/index\.html$/)
  end
end
