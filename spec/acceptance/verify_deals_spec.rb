require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature 'verify deals' do
  
  context 'normal user' do

    scenario 'cannot verify deals' do
      deal = Deal.make!(:full)
      normal = login_normal
      click_link 'Deals'
      click_link deal.summary
      page.should_not have_link 'Mark as verified?'
    end    

  end

  context 'moderator' do

    scenario 'cannot verify deal without source_url' do
      deal = Deal.make!(:full, :source_url => nil)
      login_mod
      click_link 'Deals'
      click_link deal.summary
      page.should_not have_content 'Verified!'
      page.should_not have_link 'Mark as verified?'
    end

    scenario 'can verify deal with source' do
      deal = Deal.make!(:full)
      login_mod
      click_link 'Deals'
      click_link deal.summary
      page.should have_content deal.source_url
      page.should have_content 'Not verified yet!'
      click_link 'Mark as verified?'
      page.should have_content 'Verified!'
    end

    scenario 'can unverify deal with source' do
      deal = Deal.make!(:full, :verified => true)
      login_mod
      click_link 'Deals'
      click_link deal.summary
      page.should have_content deal.source_url
      page.should have_content 'Verified'
      click_link 'Mark as unverified?'
      page.should have_content 'Not verified yet!'
    end

  end # context  

  context 'when deal is updated' do

    scenario 'should become unverified' do
      deal = Deal.make!(:full, :verified => true)
      login_normal
      click_link 'Deals'
      click_link 'Edit'
      select '2009', :from => 'Close date'
      click_button 'Update Deal'
      page.should have_content 'Not verified yet!'      
      page.should_not have_content 'Verified!'
    end

  end # context 

end # feature

