require 'rails_helper'

feature "课件页面" do
  background do
    @user = User.create(email: 'test@example.com', name: 'test', password: '123456')
    @course = @user.courses.create(:name => '测试课程', :desc => '课程描述')
    @chapter = @user.chapters.create(:name => '测试章节', :desc => '章节描述', course: @course)
  end

  describe 'after sign in' do
    before do
      visit '/auth/login'
      within("form") do
        fill_in 'session_email', :with => @user.email
        fill_in 'session_password', :with =>  @user.password
      end
      click_button '提交'
    end

    scenario "访问章节详情页" do
      visit "/chapters/#{@chapter.id}"
      expect(page).to have_content @chapter.name
      expect(page).to have_content @chapter.desc
    end

    scenario "访问章节详情页转入上传课件" do
      visit "/chapters/#{@chapter.id}"
      click_link '上传课件'
      expect(find('h1')).to have_content('上传课件')
      expect(current_path).to eq("/chapters/#{@chapter.id}/wares/new")
    end

    scenario "上传课件, 正常提交" do
      visit "/chapters/#{@chapter.id}/wares/new"
      within("#new_ware") do
        fill_in 'ware_name', :with => '课件标题'
        fill_in 'ware_desc', :with =>  '课件描述'
      end
      click_button '新增课件'
      expect(page).to have_content('修改章节信息')
      @create_ware = KcCourses::Ware.last
      expect(page).to have_content(@create_ware.name)
      expect(current_path).to eq("/chapters/#{@chapter.id}")
    end

    scenario "列表跳转进入编辑" do
      other_ware = @user.wares.create(:name => '其他标题', :desc => '其他描述', chapter: @chapter)
      visit "/chapters/#{@chapter.id}"
      click_link '编辑'
      expect(find('h1')).to have_content('修改课件')
      expect(current_path).to eq("/wares/#{other_ware.id}/edit")
    end

    scenario "修改课件, 正常提交" do
      other_ware = @user.wares.create(:name => '其他标题', :desc => '其他描述', chapter: @chapter)
      visit "/wares/#{other_ware.id}/edit"
      expect(find('h1')).to have_content('修改课件')
      within(".edit_ware") do
        fill_in 'ware_name', :with => '其他标题改'
        fill_in 'ware_desc', :with =>  '其他描述改'
      end
      click_button '更新课件'
      expect(page).to have_content('其他标题改')
      expect(current_path).to eq("/chapters/#{@chapter.id}")
    end

    scenario "列表删除" do
      other_ware = @user.wares.create(:name => '其他标题', :desc => '其他描述', chapter: @chapter)
      visit "/chapters/#{@chapter.id}"
      expect(page).to have_content(other_ware.name)
      # 默认确认
      #accept_confirm do
      click_link '删除'
      #end
      expect(page).not_to have_content(other_ware.name)
      expect(current_path).to eq("/chapters/#{@chapter.id}")
    end
  end
end
