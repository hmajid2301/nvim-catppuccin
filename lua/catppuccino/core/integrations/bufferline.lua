local M = {}

function M.get(cp)

	local inactive_clr = cp.catppuccino14

	return {
		BufferLineFill = { bg = cp.catppuccino16 },
		BufferLineBackground = { fg = cp.catppuccino13, bg = inactive_clr },
		BufferLineBufferVisible = { fg = cp.catppuccino13, bg = inactive_clr },
		BufferLineBufferSelected = { fg = cp.catppuccino0, bg = cp.catppuccino2 },
		BufferLineTab = { fg = cp.catppuccino13, bg = cp.catppuccino2 },
		BufferLineTabSelected = { fg = cp.catppuccino6, bg = cp.catppuccino10 },
		BufferLineTabClose = { fg = cp.catppuccino6, bg = inactive_clr },
		BufferLineIndicatorSelected = { fg = cp.catppuccino2, bg = cp.catppuccino2 },
		-- separators
		BufferLineSeparator = { fg = inactive_clr, bg = inactive_clr },
		BufferLineSeparatorVisible = { fg = inactive_clr, bg = inactive_clr },
		BufferLineSeparatorSelected = { fg = inactive_clr, bg = inactive_clr },
		-- close buttons
		BufferLineCloseButton = { fg = cp.catppuccino13, bg = inactive_clr },
		BufferLineCloseButtonVisible = { fg = cp.catppuccino13, bg = inactive_clr },
		BufferLineCloseButtonSelected = { fg = cp.catppuccino6, bg = cp.catppuccino2 },
	}
end

return M
