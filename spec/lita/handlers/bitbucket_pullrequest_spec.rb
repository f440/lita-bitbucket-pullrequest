require "spec_helper"

describe Lita::Handlers::BitbucketPullrequest, lita_handler: true do
  it { routes_http(:post, "/bitbucket_pullrequest").to(:receive) }

  describe "#receive" do
    before do
      Lita.config.robot.locale = :en
    end

    let(:request) do
      request = double("Rack::Request")
      allow(request).to receive(:params).and_return(params)
      allow(request).to receive(:body).and_return(body)
      request
    end
    let(:response) { Rack::Response.new }
    let(:params) { {} }
    let(:body) { StringIO.new }

    context "create pull request" do
      before do
        allow(params).to receive(:[]).with('room').and_return('foo')
        allow(request).to receive(:body).and_return(StringIO.new(fixture('pullrequest_created')))
      end
      it "responds when a pull request is created" do
        expect(robot).to receive(:send_message) do |target, message|
          expect(target.room).to eq('foo')
          expect(message).to include "created a pull request"
        end
        subject.receive(request, response)
      end
    end

    context "create comment" do
      before do
        Lita.config.robot.locale = :en
        allow(params).to receive(:[]).with('room').and_return('foo')
        allow(request).to receive(:body).and_return(StringIO.new(fixture('pullrequest_comment_created')))
      end
      it "responds when someone comment about pull request" do
        expect(robot).to receive(:send_message) do |target, message|
          expect(target.room).to eq('foo')
          expect(message).to include "commented"
        end
        subject.receive(request, response)
      end
    end
  end
end
