# frozen_string_literal: true

path = Rails.root.join('db', 'seeds', "#{Rails.env}.rb")
load path if File.exist?(path)

path = Rails.root.join('db/seeds/personal.rb')
load path if File.exist?(path)
