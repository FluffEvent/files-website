import type { AstroUserConfig } from 'astro/config'

export const i18n =
{
	defaultLocale: 'fr',
	locales: [
		{
			codes: ['en', 'en-US'],
			path: 'en',
		},
		{
			codes: ['fr', 'fr-FR'],
			path: 'fr',
		},
	],
	routing: {
		prefixDefaultLocale: false,
	},
} as const satisfies AstroUserConfig['i18n']
