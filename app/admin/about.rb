# frozen_string_literal: true

ActiveAdmin.register_page 'About' do
  menu priority: 41

  content do
    div class: 'max-w-3xl mx-auto py-8 px-4' do
      para I18n.t('about.description'), class: 'mb-8'

      div class: 'bg-yellow-50 border-l-4 border-yellow-400 p-4 mb-8' do
        para I18n.t('about.disclaimer.title'), class: 'text-lg font-semibold text-yellow-800 mb-2'
        para I18n.t('about.disclaimer.text'), class: 'text-yellow-700'
      end

      div class: 'mb-8' do
        para I18n.t('about.source_code.title'), class: 'text-lg font-semibold mb-4'
        para do
          text_node I18n.t('about.source_code.text')
          a 'github.com/thisismydesign/wealth',
            href: 'https://github.com/thisismydesign/wealth',
            target: '_blank'
        end
      end

      div do
        h3 I18n.t('about.support.title'), class: 'text-lg font-semibold mb-4'
        para I18n.t('about.support.text'), class: 'mb-4'

        div class: 'space-y-4' do
          div do
            h4 I18n.t('about.support.eth.title'), class: 'font-medium mb-2'
            code ConfigService.call(key: [:eth_address]),
                 class: 'block p-2 rounded text-sm font-mono'
          end

          div do
            h4 I18n.t('about.support.btc.title'), class: 'font-medium mb-2'
            code ConfigService.call(key: [:btc_address]),
                 class: 'block p-2 rounded text-sm font-mono'
          end
        end
      end
    end
  end
end
