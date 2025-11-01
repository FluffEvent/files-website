import { defineMarkdocConfig, component } from '@astrojs/markdoc/config'

export default defineMarkdocConfig({
	tags: {
		i18n: {
			render: component('./src/components/markdoc/I18n.astro'),
			attributes: {
				locales: { type: Object, required: true },
				renderMarkdown: { type: Boolean, default: false },
			},
		},
	},
})
