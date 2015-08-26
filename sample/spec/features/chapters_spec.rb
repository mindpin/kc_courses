require 'rails_helper'

feature "章节页面" do
  background do
    @user = User.create(email: 'test@example.com', name: 'test', password: '123456')
    @course = @user.courses.create(:title => '测试标题', :desc => '测试描述')
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

    scenario "访问课程详情页" do
      visit "/courses/#{@course.id}"
      expect(page).to have_content @course.title
      expect(page).to have_content @course.desc
    end

    scenario "访问课程详情页转入增加章节" do
      visit "/courses/#{@course.id}"
      click_link '增加章节'
      expect(find('h1')).to have_content('增加章节')
      expect(current_path).to eq("/courses/#{@course.id}/chapters/new")
    end

    scenario "增加课程, 正常提交" do
      visit "/courses/#{@course.id}/chapters/new"
      within("#new_chapter") do
        fill_in 'chapter_title', :with => '章节标题'
        fill_in 'chapter_desc', :with =>  '章节描述'
      end
      click_button '新增章节'
      expect(page).to have_content('修改章节信息')
      @create_chapter = KcCourses::Chapter.last
      expect(current_path).to eq("/chapters/#{@create_chapter.id}")
    end

    scenario "列表跳转进入编辑" do
      other_chapter = @user.chapters.create(:title => '其他标题', :desc => '其他描述', course: @course)
      visit "/courses/#{@course.id}"
      click_link '编辑'
      expect(find('h1')).to have_content('修改章节')
      expect(current_path).to eq("/chapters/#{other_chapter.id}/edit")
    end

    scenario "修改章节, 正常提交" do
      other_chapter = @user.chapters.create(:title => '其他标题', :desc => '其他描述', course: @course)
      visit "/chapters/#{other_chapter.id}/edit"
      expect(find('h1')).to have_content('修改章节')
      within(".edit_chapter") do
        fill_in 'chapter_title', :with => '其他标题改'
        fill_in 'chapter_desc', :with =>  '其他描述改'
      end
      click_button '更新章节'
      expect(page).to have_content('其他标题改')
      expect(page).to have_content('其他描述改')
      expect(current_path).to eq("/chapters/#{other_chapter.id}")
    end

    scenario "列表删除" do
      other_chapter = @user.chapters.create(:title => '其他标题', :desc => '其他描述', course: @course)
      visit "/courses/#{@course.id}"
      expect(page).to have_content(other_chapter.title)
      # 默认确认
      #accept_confirm do
        click_link '删除'
      #end
      expect(page).not_to have_content(other_chapter.title)
      expect(current_path).to eq("/courses/#{@course.id}")
    end
  end
end
