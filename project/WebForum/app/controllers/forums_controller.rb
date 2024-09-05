class ForumsController < ApplicationController
    before_action :forum_finding, only: [:show, :edit, :update]

    def index
        @forums = Forum.all.order("created_at DESC")
    end

    def new
        @forum = Forum.new
    end

    def create
        @forum = Forum.new(forum_params)
        if @forum.save
            redirect_to root_path
        else
            render 'new'
        end
    end

    def update
        if @forum.update(forum_params)
            redirect_to root_path
        else
            render 'edit'
        end
    end

    private

    def forum_params
        params.require(:forum).permit(:thread, :content)
    end

    def forum_finding
        @forum = Forum.find(params[:id])
    end
end
