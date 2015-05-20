FactoryGirl.define do
  factory :oauth_application, class: Doorkeeper::Application do
    name 'test'
    redirect_uri "urn:ietf:wg:oauth:2.0:oob"
    uid Faker::Code.ean
    secret Faker::Code.ean
  end
end
