# encoding: UTF-8
class UsersController < ApplicationController
  before_filter :authenticate_user!, :except => [:index, :show]
  # GET /users.xml
  def index
    @title = "メンバー一覧"
    @users = (User.includes(:ranks).where("ranks.created_at > ?", Time.now - 1.year) + User.where("created_at > ?", Time.now - 6.month)).uniq

    respond_to do |format|
      format.html # index.html.erb
      format.csv  { render :csv => @users }
    end
  end

  # GET /users/名前
  # GET /users/1.xml
  def show
    unless @user = User.find_by_name(params[:name])
      redirect_to(:action => 'index', :notice => '存在しないユーザーです')
      return
    end
    @title = "#{@user.name}"
    @ranks = @user.ranks.where(:ranking_id => Ranking.where(:is_registerable => 1)).sort{|a, b| (a.ranking_id <=> b.ranking_id).nonzero? or a.rank <=> b.rank}
    @do_show_ranking = current_user == @user || complete_ranking(Ranking.where(:is_registerable => 1).min{|r| r.id})

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @user }
      format.csv  { render :csv => @user }
    end
  end

  # GET /users/new
  # GET /users/new.xml
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /users
  # POST /users.xml
  def create
    if current_user
      redirect_to(user_path(current_user.name), :notice => '一つのログイン情報に一つを超えるユーザー情報は登録できません')
      return
    end

    @user = User.new(params[:user])
    current_userauth.user = @user

    respond_to do |format|
      if @user.save
        current_userauth.save!
        format.html { redirect_to(user_path(@user.name), :notice => 'User was successfully created.') }
        format.xml  { render :xml => @user, :status => :created, :location => @topic }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.xml
  def update
    @user = User.find(params[:id])
    unless @user.id == current_user.id
      redirect_to(user_path(current_user.name), :notice => '他のユーザーは編集できません')
      return
    end

    @user.name.gsub!(/[\.\/]/, "")
    #params[:user].each{|k,v| params[:user][k].gsub!(/\/\./, "") if k == :name}

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to(user_path(@user.name), :notice => 'User was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.xml
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to(users_url) }
      format.xml  { head :ok }
    end
  end
end
