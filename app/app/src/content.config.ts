import { defineCollection, z } from 'astro:content'
import { glob } from 'astro/loaders'

export const collections = {
	documents: defineCollection({
		loader: glob({ pattern: '**/*.(md|mdoc)', base: './src/content/documents' }),
		schema: z.object({
			version: z.string().optional(),
		}),
	}),
	'private-documents': defineCollection({
		loader: glob({ pattern: '**/*.(md|mdoc)', base: './src/content/private-documents' }),
		schema: z.object({
			version: z.string().optional(),
		}),
	}),
}
