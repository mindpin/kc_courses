require 'rails_helper'

feature "收藏页面" do
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

    scenario "收藏" do
      visit "/courses/#{@course.id}"
      click_link '收藏'
      expect(find('h1')).to have_content('我的收藏')
      expect(current_path).to eq('/favorites')
    end

    scenario "收藏成功" do
      visit "/courses/#{@course.id}"
      click_link '收藏'
      visit "/favorites"
      expect(page).to have_content(@course.title)
    end

    scenario "重复收藏失败" do
      visit "/courses/#{@course.id}"
      click_link '收藏'
      visit "/courses/#{@course.id}"
      click_link '收藏'
      expect(current_path).to eq("/courses/#{@course.id}")
    end

    scenario "列表删除" do
      visit "/courses/#{@course.id}"
      click_link '收藏'
      visit "/favorites"
      expect(page).to have_content('删除')
      # js confirm已经默认确认
      #accept_confirm do
        click_link '删除'
      #end
      expect(page).not_to have_content(@course.title)
    end
  end
end

