class ForumsController < ApplicationController
    before_action :forum_finding, only: [:show, :edit, :update, :destroy]
    before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]

    def index
        @forums = Forum.all.order("created_at DESC")
        @user = current_user
    end

    def new
        @forum = current_user.forums.build
    end

    def create
        @forum = current_user.forums.build(forum_params)
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

    def destroy
        @forum.destroy
        redirect_to root_path
    end

    private

    def forum_params
        params.require(:forum).permit(:thread, :content)
    end

    def forum_finding
        @forum = Forum.find(params[:id])
    end
end
