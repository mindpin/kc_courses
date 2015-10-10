require 'rails_helper'

feature "参与课程页面" do
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

    scenario "我要参加" do
      visit "/courses/#{@course.id}"
      click_link '我要参加'
      expect(find('h1')).to have_content('我参加的课程')
      expect(current_path).to eq('/joins')
    end

    scenario "参加成功" do
      visit "/courses/#{@course.id}"
      click_link '我要参加'
      visit "/joins"
      expect(page).to have_content(@course.title)
    end

    scenario "重复参加,失败" do
      visit "/courses/#{@course.id}"
      click_link '我要参加'
      visit "/courses/#{@course.id}"
      click_link '我要参加'
      expect(current_path).to eq("/courses/#{@course.id}")
    end

    scenario "列表删除" do
      visit "/courses/#{@course.id}"
      click_link '我要参加'
      visit "/joins"
      expect(page).to have_content('删除')
      # js confirm已经默认确认
      #accept_confirm do
        click_link '删除'
      #end
      expect(page).not_to have_content(@course.title)
    end
  end
end


