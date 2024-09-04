class ForumsController < ApplicationController
    def index
    end

    def new
        @forum = Forum.new
    end
end
