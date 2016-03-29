require 'rails_helper'

feature "课程页面" do
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

    scenario "访问课程主页" do
      visit '/courses'
      expect(page).to have_content '增加课程'
    end

    scenario "课程主页转入增加课程" do
      visit '/courses'
      click_link '增加课程'
      expect(find('h1')).to have_content('增加课程')
      #expect(current_path).to eq(new_course_path) # 由于new_course_path不属于Rails项目，所以会失败
      expect(current_path).to eq('/courses/new')
    end

    scenario "增加课程, 正常提交" do
      visit '/courses/new'
      within("#new_course") do
        fill_in 'course_title', :with => '课程标题'
        fill_in 'course_desc', :with =>  '课程描述'
      end
      click_button '新增课程'
      expect(page).to have_content('上课时间')
      expect(current_path).to match(/\/courses\/\S+/)
    end

    scenario "列表跳转进入编辑" do
      visit "/courses"
      expect(page).to have_content(@course.title)
      click_link '编辑'
      expect(find('h1')).to have_content('修改课程')
      expect(current_path).to match(/\/courses\/\S+\/edit/)
    end

    scenario "修改课程, 正常提交" do
      visit "/courses/#{@course.id}/edit"
      expect(find('h1')).to have_content('修改课程')
      within(".edit_course") do
        fill_in 'course_title', :with => '其他标题改'
        fill_in 'course_desc', :with =>  '其他描述改'
      end
      click_button '更新课程'
      expect(page).to have_content('其他标题改')
      expect(page).to have_content('其他描述改')
      expect(current_path).to match(/\/courses\/\S+/)
    end

    scenario "列表删除" do
      visit "/courses"
      expect(page).to have_content(@course.title)
      expect(page).to have_content('删除')
      # js confirm已经默认确认
      #accept_confirm do
        click_link '删除'
      #end
      expect(page).not_to have_content(@course.title)
      expect(current_path).to match(/\/courses/)
    end

  end
end
