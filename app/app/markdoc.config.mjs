import { defineMarkdocConfig, component } from '@astrojs/markdoc/config'

export default defineMarkdocConfig({
	tags: {
		i18n: {
			render: component('./src/components/markdoc/Translate.astro'),
			attributes: {
				en: { type: String, required: true },
				fr: { type: String },
			},
		},
	},
})
