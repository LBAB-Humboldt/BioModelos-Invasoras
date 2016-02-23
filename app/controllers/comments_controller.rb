class CommentsController < ApplicationController
  
  def create
  	@comment_hash = params[:comment]
  	if (params[:comment].has_key?(:parent_id) && !params[:comment][:parent_id].blank?)
    	@parent = Comment.find(params[:comment][:parent_id])
	end
  	@obj = @comment_hash[:commentable_type].constantize.find(@comment_hash[:commentable_id])
  	 # Not implemented: check to see whether the user has permission to create a comment on this object
  	@comment = Comment.build_from(@obj, current_user.id, @comment_hash[:body])

  	if @comment.save
        # render :partial => "comments/comment", :locals => { :comment => @comment }, :layout => false, :status => :created
        if @parent
        	@comment.move_to_child_of(@parent)
      	end
        respond_to do |format|
        	format.js
        end
    else
        render :js => "alert('Se ha producido un error guardando el comentario.');"
    end
  end

  def edit
    @comment = Comment.find(params[:id])

    respond_to do |format|
          format.js
    end
  end

  def update
    @comment = Comment.find(params[:id])

    if @comment.update_attributes(comment_params)
      respond_to do |format|
          format.js
      end
    else
      render :js => "alert('Se ha producido un error editando el comentario.');"
    end
  end

  def destroy
    @comment = Comment.find(params[:id])

    if @comment.destroy
        respond_to do |format|
          format.js
        end
    else
        render :js => "alert('Se ha producido un error eliminando el comentario.');"
    end
  end

  def child_comments
  	@id_parent = params[:parent_id]

  	respond_to do |format|
  		  format.html
        format.js
    end
  end

  private

    def comment_params
        params.require(:comment).permit(:body)
    end

end
