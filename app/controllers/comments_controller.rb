require 'RMagick'

class CommentsController < ApplicationController
  before_filter :authorize, :except => [:create, :sticky]
  
  # GET /comments
  # GET /comments.xml
  def index
    @comments = Comment.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @comments }
    end
  end

  # GET /comments/1
  # GET /comments/1.xml
  def show
    @comment = Comment.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @comment }
    end
  end

  # GET /comments/new
  # GET /comments/new.xml
  def new
    @comment = Comment.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @comment }
    end
  end

  # GET /comments/1/edit
  def edit
    @comment = Comment.find(params[:id])
  end

  # POST /comments
  # POST /comments.xml
  def create
    @comment = Comment.new(params[:comment])

    respond_to do |format|
      if @comment.save
        #flash[:notice] = 'Comment was successfully created.'
        format.js if request.xhr?
        format.html { redirect_to(root_url) }
        format.xml  { render :xml => @comment, :status => :created, :location => @comment }
      else
        flash[:notice] = 'Unable to save your comment at this time. Jerk.'
        format.html { redirect_to(root_url) }
        format.xml  { render :xml => @comment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /comments/1
  # PUT /comments/1.xml
  def update
    @comment = Comment.find(params[:id])

    respond_to do |format|
      if @comment.update_attributes(params[:comment])
        flash[:notice] = 'Comment was successfully updated.'
        format.html { redirect_to(@comment) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @comment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.xml
  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy

    respond_to do |format|
      format.html { redirect_to(comments_url) }
      format.xml  { head :ok }
    end
  end
  
  def sticky
    @comment = Comment.find(params[:id])
    colors = %w(yellow purple green)
    image = "#{RAILS_ROOT}/public/images/post-it-blank-#{colors[rand(colors.size)]}.png"
    
    paper = Magick::Image.read(image).first
    text = Magick::Draw.new
    anno = Magick::Image.new(paper.columns - (paper.columns/30), paper.rows) do
      self.background_color = 'none'
    end
    
    cap_line = ""
    formatted_cap = ""
    cap_words = @comment.body.split(" ")
    
    cap_words.each {|w|
      cap_line += "#{w}\s"
      if cap_line.length > 20 then
      curr_words = cap_line.split("\s")
      cap_line = "#{curr_words.pop}\s"
        formatted_cap = "#{formatted_cap}\n#{curr_words.join(' ')}"
      end
    }
    formatted_cap = "#{formatted_cap}\n#{cap_line}"
    
    text.annotate(anno,anno.columns,anno.rows,15,25, formatted_cap) {
      self.gravity = Magick::NorthGravity
      self.pointsize = 15
      self.stroke = 'transparent'
      self.fill = '#000000'
      self.align = Magick::LeftAlign
      self.font_weight = Magick::BoldWeight
      self.font_family = "Arial"
    }
    anno.rotate!(-8.2)
    comp = paper.composite(anno,Magick::CenterGravity,Magick::OverCompositeOp)
    image = comp.to_blob
    #comp.write("#{RAILS_ROOT}/public/images/sticky#{@comment.id}.png")
    send_data image,
      :filename => "sticky#{@comment.id}.png",
      :type => "image/png",
      :disposition => "inline"
  end
end
