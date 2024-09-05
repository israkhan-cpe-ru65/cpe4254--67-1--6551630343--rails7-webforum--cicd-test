class ForumsController < ApplicationController
    def index
    end

    def new
        @forum = Forum.new
    end

    private
    def forum_params
        params.require(:forum).permit(:thread, :content)
    end
end
