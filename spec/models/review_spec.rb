# frozen_string_literal: true

require "rails_helper"

RSpec.describe Review do
  describe "associations" do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:potion) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:rating) }
    it { is_expected.to validate_presence_of(:comment) }
    it { is_expected.to validate_numericality_of(:rating).is_greater_than_or_equal_to(1) }
    it { is_expected.to validate_numericality_of(:rating).is_less_than_or_equal_to(5) }
    it { is_expected.to validate_numericality_of(:rating).only_integer }
  end

  describe "attribute validations" do
    it "is valid with valid attributes" do
      review = build(:review)

      expect(review).to be_valid
    end

    it "is invalid with no potion" do
      review = build(:review, potion: nil)

      expect(review).not_to be_valid
    end

    it "is invalid with no user" do
      review = build(:review, user: nil)

      expect(review).not_to be_valid
    end

    it "is invalid with no rating" do
      review = build(:review, rating: nil)

      expect(review).not_to be_valid
    end

    it "is invalid with no comment" do
      review = build(:review, comment: nil)

      expect(review).not_to be_valid
    end

    it "is invalid with a rating that is too high" do
      review = build(:review, rating: 7)

      expect(review).not_to be_valid
    end

    it "is invalid with a rating that is too low" do
      review = build(:review, rating: 0)

      expect(review).not_to be_valid
    end

    it "is invalid with a rating that is not an integer" do
      review = build(:review, rating: 3.0)

      expect(review).not_to be_valid
    end
  end

  describe ".most_recent" do
    it "returns the most recent reviews by default (limit 3)" do
      reviews = []
      5.times do |i|
        reviews << create(:review, created_at: (5 - i).hours.ago)
      end

      most_recent = described_class.most_recent

      expect(most_recent).to eq(reviews.last(3).reverse)
    end

    it "respects a custom limit" do
      reviews = []
      5.times do |i|
        reviews << create(:review, created_at: (5 - i).hours.ago)
      end

      most_recent = described_class.most_recent(2)

      expect(most_recent).to eq(reviews.last(2).reverse)
    end
  end

  describe "#rating_stars" do
    it "returns one star for rating of 1" do
      review = create(:review, rating: 1)

      stars = review.rating_stars

      expect(stars).to eql("⭐️")
    end

    it "returns three stars for rating of 3" do
      review = create(:review, rating: 3)

      stars = review.rating_stars

      expect(stars).to eql("⭐️⭐️⭐️")
    end

    it "returns five stars for rating of 5" do
      review = create(:review, rating: 5)

      stars = review.rating_stars

      expect(stars).to eql("⭐️⭐️⭐️⭐️⭐️")
    end
  end

  describe "#edited?" do
    context "when the created_at and updated_at are different" do
      it "returns true" do
        review = create(:review, created_at: "2025-09-09 14:59:51.730008000 UTC +00:00",
                                 updated_at: "2025-09-18 14:59:51.730008000 UTC +00:00")

        expect(review.edited?).to be(true)
      end
    end

    context "when the created_at and updated_at are the same" do
      it "returns false" do
        review = create(:review, created_at: "2025-09-09 14:59:51.730008000 UTC +00:00",
                                 updated_at: "2025-09-09 14:59:51.730008000 UTC +00:00")

        expect(review.edited?).to be(false)
      end
    end
  end

  describe "#formatted_created_at" do
    it "returns the formatted created_at string" do
      time = Time.zone.local(2025, 9, 10, 14, 30, 0)
      review = create(:review, created_at: time)
      expect(review.formatted_created_at).to eq(time.localtime.strftime("%b %d, %Y %I:%M %p"))
    end
  end

  describe "#formatted_updated_at" do
    it "returns the formatted updated_at string" do
      time = Time.zone.local(2025, 9, 10, 16, 45, 0)
      review = create(:review, updated_at: time)
      expect(review.formatted_updated_at).to eq(time.localtime.strftime("%b %d, %Y %I:%M %p"))
    end
  end

  describe ".recent_for_user" do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }
    let!(:three_day_old_review) { create(:review, user: user, created_at: 3.days.ago) }
    let!(:two_day_old_review) { create(:review, user: user, created_at: 2.days.ago) }
    let!(:one_day_old_review) { create(:review, user: user, created_at: 1.day.ago) }
    let!(:review_from_other_user) { create(:review, user: other_user, created_at: 1.day.ago) }

    it "returns only reviews for the given user" do
      expect(described_class.recent_for_user(user)).to all(have_attributes(user_id: user.id))
    end

    it "returns reviews in descending order of creation" do
      reviews = described_class.recent_for_user(user)
      expect(reviews).to eq([one_day_old_review, two_day_old_review, three_day_old_review])
    end

    it "limits the number of reviews returned (default 5)" do
      expect(described_class.recent_for_user(user).count).to be <= 5
    end

    it "respects a custom limit" do
      expect(described_class.recent_for_user(user, 2)).to eq([one_day_old_review, two_day_old_review])
    end

    it "does not include reviews from other users" do
      expect(described_class.recent_for_user(user)).not_to include(review_from_other_user)
    end
  end
end
