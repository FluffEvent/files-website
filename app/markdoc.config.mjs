import { defineMarkdocConfig, component, nodes } from '@astrojs/markdoc/config'

export default defineMarkdocConfig({
	nodes: {
		document: {
			...nodes.document,
			render: null,
		},
	},
	tags: {
		signatures: {
			render: component('./src/components/Signatures.astro'),
			attributes: {
				data: { type: Array },
			},
		},
	},
})
