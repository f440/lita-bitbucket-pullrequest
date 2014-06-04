module Lita
  module Handlers
    class BitbucketPullrequest < Handler
      http.post "/bitbucket_pullrequest", :receive

      def receive(request, response)
        I18n.locale = Lita.config.robot.locale

        room = request.params['room']
        target = Source.new(room: room)
        data = parse(request.body.read)
        message = format(data)
        return if message.nil?
        robot.send_message(target, message)
      end

      private

      def parse(json)
        MultiJson.load(json, symbolize_keys: true)
      rescue MultiJson::ParseError => exception
        exception.data
        exception.cause
      end

      def format(data)
        type, content = data.first
        case type
        when :pullrequest_approve
        when :pullrequest_unapprove
          # These can't recognize the repository name.
          # ref. [Pull Request POST hook does not include links to related objects (BB-9535)t](https://bitbucket.org/site/master/issue/8340/pull-request-post-hook-does-not-include)

        when :pullrequest_comment_created
          t("pullrequest_comment_created",
            name: content[:user][:display_name],
            url: content[:links][:html][:href].sub(/api\./, ''))
        when :pullrequest_comment_deleted
          t("pullrequest_comment_deleted",
            name: content[:user][:display_name],
            url: content[:links][:html][:href].sub(/api\./, ''))
        when :pullrequest_comment_updated
          t("pullrequest_comment_deleted",
            name: content[:user][:display_name],
            url: content[:links][:html][:href].sub(/api\./, ''))
        when :pullrequest_created
          t("pullrequest_created",
            name: content[:author][:display_name],
            title: content[:title],
            url: "https://bitbucket.org/#{content[:destination][:repository][:full_name]}/pull-request/#{content[:id]}/")
        when :pullrequest_merged
          t("pullrequest_merged",
            name: content[:author][:display_name],
            title: content[:title],
            url: "https://bitbucket.org/#{content[:destination][:repository][:full_name]}/branch/#{content[:destination][:branch][:name]}")
        when :pullrequest_declined
          t("pullrequest_declined",
            name: content[:author][:display_name],
            title: content[:title],
            url: "https://bitbucket.org/#{content[:destination][:repository][:full_name]}/pull-requests?displaystatus=declined")
        when :pullrequest_updated
          t("pullrequest_updated",
            name: content[:author][:display_name],
            title: content[:title],
            url: "https://bitbucket.org/#{content[:destination][:repository][:full_name]}/pull-request/")
        end
      end
    end

    Lita.register_handler(BitbucketPullrequest)
  end
end
