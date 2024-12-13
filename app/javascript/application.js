// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails

// Disabled until fixed: https://github.com/activeadmin/activeadmin/issues/8577
import "@hotwired/turbo-rails"
import "controllers"

// Admin
import "active_admin"

// Charts
import "chartkick"
import "Chart.bundle"

// https://github.com/activeadmin/activeadmin/discussions/8573
import 'flowbite';
