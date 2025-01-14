require 'rails_helper'

RSpec.describe Mechanic, type: :feature do 
  describe 'Mechanic show page' do 
    
    before (:each) do 
      @six_flags = AmusementPark.create!(name: 'Six Flags', admission_cost: 75) 
      @molly = Mechanic.create!(name: "Molly Master Mechanic", years_experience: 25) 
      @mind_eraser = Ride.create!(amusement_park_id: @six_flags.id, name: "Mind Eraser", thrill_rating: 7, open: false) 
      @side_winder = Ride.create!(amusement_park_id: @six_flags.id, name: "Side Winder", thrill_rating: 4, open: true) 
      @heart_stopper = Ride.create!(amusement_park_id: @six_flags.id, name: "Heart Stopper", thrill_rating: 4, open: true) 
      MechanicRide.create!(mechanic_id: @molly.id, ride_id: @mind_eraser.id)
      MechanicRide.create!(mechanic_id: @molly.id, ride_id: @side_winder.id)
      visit "/mechanics/#{@molly.id}"
    end
    it "displays the mechanics name" do
      expect(page).to have_content("Mechanic: Molly Master Mechanic")
    end
     
    it 'displays their years of experience' do 
      expect(page).to have_content("Years of experience: 25")
    end

    it 'displays all of the rides they are working on' do
     
      expect(page).to have_content("Working On:")
      within "#rides-#{@mind_eraser.id}" do 
        expect(page).to have_content("Mind Eraser")
      end
      within "#rides-#{@side_winder.id}" do 
        expect(page).to have_content("Side Winder")
      end
    end

    it "displays a form to add a ride to their workload and adds the ride" do 
      fill_in 'Ride id:', with: "#{@heart_stopper.id}"
      
      click_on 'Submit'
      expect(current_path).to eq("/mechanics/#{@molly.id}")
  
     within "#rides-#{@mind_eraser.id}" do 
        expect(page).to have_content("Mind Eraser")
      end

     within "#rides-#{@side_winder.id}" do 
        expect(page).to have_content("Side Winder")
      end

     within "#rides-#{@heart_stopper.id}" do 
        expect(page).to have_content("Heart Stopper")
      end
    end
  end

end