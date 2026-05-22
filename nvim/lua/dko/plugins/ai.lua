local uis = vim.api.nvim_list_uis()
local has_ui = #uis > 0

---@diagnostic disable: unused-local

local function create_ai_config(base_url, api_key, model, temperature)
  return {
    client = {
      base_url = base_url,
      api_key = api_key,
    },
    request = {
      temperature = temperature or 0.0001,
      model = model,
      stream = true,
    },
  }
end

local gemini = create_ai_config(
  "https://generativelanguage.googleapis.com/v1beta/openai/",
  vim.fn.getenv("GOOGLE_API_KEY") or vim.fn.getenv("GEMINI_API_KEY"),
  "gemini-2.0-flash"
)

local groq = create_ai_config(
  "https://api.groq.com/openai/v1",
  vim.fn.getenv("GROQ_API_KEY_DANTE_NVIM"),
  "llama-3.3-70b-versatile"
)

local copilot = create_ai_config("https://api.githubcopilot.com", nil, "gpt-4o")

local lmstudio = create_ai_config(
  "http://localhost:1234/v1",
  "here-is-a-dummy-api-key",
  "llama-3.2-3b-instruct"
)

-- present can be gemini, groq, copilot, or lmstudio
local preset = copilot

local presets = {
  default = preset,

  -- grammar
  ["grammar"] = vim.tbl_deep_extend("force", preset, {
    request = {
      temperature = 0.2,
      messages = {
        {
          role = "system",
          content = [[
You are a precise proofreader tasked with correcting grammatical errors and typos in text.

Your responsibilities:
- Fix spelling mistakes
- Correct grammatical errors
- Rectify punctuation issues
- Do not change the original wording or phrasing
- Do not alter the text's structure or format
- Maintain the author's voice and style
- Preserve all original content, including technical terms and jargon
- Make no improvements to clarity or readability beyond grammar and spelling fixes
- Include the comment if the are comments in the original text (e.g. // or % in LaTeX)
- If the text is formatted in a specific syntax (e.g., LaTeX, Markdown, Vimdoc, ...), abide by that syntax.
- Use the same language and terminology appropriate for the context.
- Return only the enhanced text without commentary.
- Maintain the integrity of the original text's line breaks and spacing (i.e., follow the original text's `\n`)

Return only the corrected text.
Do not explanations, or formatting to your response.
]],
        },
        {
          role = "user",
          content = "{{SELECTED_LINES}}",
        },
      },
    },
  }),

  -- rewrite
  ["rewrite"] = vim.tbl_deep_extend("force", preset, {
    request = {
      temperature = 0.2,
      messages = {
        {
          role = "system",
          content = [[
You are a professional academic rewriter. Your task is to revise a paper. Here are some requirements:
- The revised content must be in English.
- Provide a revised version that maintains the original intent while improving the overall flow, clarity, and language used.
- Please do not utilize over-complicated words, and make changes when it is necessary.
- Please following the writing style of top AI conferences, such as CVPR, ICCV, ICML and NeuralIPS.
- Ensure all lines are 78 characters or less in length.
- Include the comment if the are comments in the original text (e.g. // or % in LaTeX)

Return only the corrected text.
Do not explanations, or formatting to your response.
]],
        },
        {
          role = "user",
          content = "{{SELECTED_LINES}}",
        },
      },
    },
  }),

  -- vimdoc
  ["vimdoc"] = vim.tbl_deep_extend("force", preset, {
    request = {
      temperature = 0.5,
      messages = {
        {
          role = "system",
          content = [[
You are an experienced Vim/Neovim plugin developer with extensive knowledge of help file syntax and conventions. Your task is to refine the documentation for a Vim/Neovim plugin.

The user is writing or updating documentation for a Vim/Neovim plugin.
The text is written in Vim help file syntax.
As a documentation expert, your responsibilities include:
- Correct spelling, grammar, and punctuation errors.
- Ensure all lines are 78 characters or less in length.
- Maintain the original Vim help file syntax, tags, and formatting.
- Preserve existing line breaks and vertical spacing.
- Use consistent terminology and follow Vim/Neovim documentation conventions.
- Clarify ambiguous instructions or explanations without altering the content's meaning.
- Optimize wording for clarity and conciseness while retaining technical accuracy.
- Ensure proper use of help tags, local options, and cross-references.
- Verify that code examples and key mappings are correctly formatted.
Return only the enhanced Vim/Neovim plugin documentation.
Do not add explanations or enclose the text in any formatting.
]],
        },
        {
          role = "user",
          content = "{{SELECTED_LINES}}",
        },
      },
    },
  }),

  -- CONTRIBUTING.md
  ["CONTRIBUTING.md"] = vim.tbl_deep_extend("force", preset, {
    request = {
      temperature = 0.2,
      messages = {
        {
          role = "system",
          content = [[
You are an experienced open-source project maintainer with a keen eye for documentation. Your project has gained popularity, and you want to ensure your CONTRIBUTING.md file is top-notch to welcome new contributors effectively. You've decided to refine the existing file without adding new sections.

The user is refining an existing CONTRIBUTING.md file on GitHub
The text is in Markdown format.
As the project maintainer, your task is to improve the quality of the CONTRIBUTING.md file:
- Fix spelling, grammar, and punctuation errors.
- Maintain the original Markdown structure and formatting.
- Clarify ambiguous or unclear instructions without adding new information.
- Ensure consistent terminology and style throughout the document.
- Optimize sentence structure for readability and conciseness.
- Align existing content with open-source contribution best practices.
- Make minimal changes to allow for easy git diff comparison.
Return only the enhanced CONTRIBUTING.md content.
Do not add explanations or enclose the text in backticks.
]],
        },
        {
          role = "user",
          content = "{{SELECTED_LINES}}",
        },
      },
    },
  }),

  -- GitHub issue
  ["ISSUE"] = vim.tbl_deep_extend("force", preset, {
    request = {

      temperature = 1.0,
      messages = {
        {
          role = "system",
          content = [[
You are a helpful and professional open-source project maintainer. Your role is to assist users in creating clear, concise, and effective GitHub issues or responses.

The user is interacting with a GitHub issue (creating, commenting, or responding).
The text is written in GitHub-flavored Markdown.
As an experienced maintainer, your tasks include:
- Correct spelling, grammar, and punctuation errors.
- Maintain the original Markdown formatting and structure.
- Preserve the author's intent and key points.
- Enhance clarity and readability without changing the core message.
- Ensure the text follows GitHub issue best practices:
  * Use clear, descriptive titles
  * Provide necessary context and background information
  * Include steps to reproduce for bug reports
  * Use appropriate issue labels and formatting
  * Keep responses courteous, constructive, and on-topic
- Optimize for brevity while retaining all essential information.
- Use neutral, inclusive language appropriate for a diverse community.
- Format code snippets, logs, or error messages correctly.
- Suggest relevant issue templates if applicable.
Return only the enhanced GitHub issue text or response.
Do not add explanations or enclose the text in any special formatting.
]],
        },
        {
          role = "user",
          content = "{{SELECTED_LINES}}",
        },
      },
    },
  }),

  -- README.md
  ["README.md"] = vim.tbl_deep_extend("force", preset, {
    request = {

      temperature = 0.8,
      messages = {
        {
          role = "system",
          content = [[
You are a skilled technical writer and open-source enthusiast with expertise in crafting compelling project documentation. Your task is to enhance a GitHub repository's README.md file.

The user is writing or updating a README.md for a GitHub repository.
The text is written in GitHub-flavored Markdown.
As an expert documentation refiner, your responsibilities include:
- Correct spelling, grammar, and punctuation errors.
- Maintain the original Markdown structure and formatting.
- Preserve existing line breaks and spacing for readability.
- Enhance the overall clarity and engagement of the content:
  * Craft a concise and appealing project description
  * Ensure the project's key features are highlighted effectively
  * Improve the structure and flow of information
  * Add or refine section headings for better navigation
  * Optimize installation and usage instructions for clarity
  * Enhance code examples and command-line instructions
- Incorporate best practices for README files:
  * Include badges for build status, version, license, etc.
  * Add a table of contents for longer READMEs
  * Ensure proper formatting of links, images, and tables
  * Include information on contributing, code of conduct, and licensing
- Suggest visuals (screenshots, diagrams, or logos) where appropriate
- Optimize for both skimmability and in-depth reading
- Ensure the tone is professional yet welcoming to potential contributors
- Verify that all links are functional and point to the correct resources
Return only the enhanced README.md content.
Do not add explanations or enclose the text in any special formatting.
]],
        },
        {
          role = "user",
          content = "{{SELECTED_LINES}}",
        },
      },
    },
  }),
}

return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({
        suggestion = { enabled = false },
        panel = { enabled = false },
      })
    end,
  },

  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    lazy = false,
    version = false, -- set this if you want to always pull the latest change
    opts = {
      provider = "copilot",
      providers = {
        copilot = {
          model = "gpt-4o",
          extra_request_body = {
            max_tokens = 4096,
          },
        },
      },
    },
    build = "make",
    dependencies = {
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      --- The below dependencies are optional,
      "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
      "zbirenbaum/copilot.lua", -- for providers='copilot'
      {
        -- support for image pasting
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        opts = {
          -- recommended settings
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
              insert_mode = true,
            },
            -- required for Windows users
            use_absolute_path = true,
          },
        },
      },
      {
        "MeanderingProgrammer/render-markdown.nvim",
        opts = {
          file_types = { "markdown", "Avante" },
        },
        ft = { "markdown", "Avante" },
      },
    },
    keys = {
      {
        "<leader>aa",
        function()
          require("avante.api").ask()
        end,
        desc = "avante: ask",
        mode = { "n", "v" },
      },
      {
        "<leader>ar",
        function()
          require("avante.api").refresh()
        end,
        desc = "avante: refresh",
      },
      {
        "<leader>ae",
        function()
          require("avante.api").edit()
        end,
        desc = "avante: edit",
        mode = "v",
      },
    },
  },

  -- https://github.com/S1M0N38/dante.nvim
  {
    "S1M0N38/dante.nvim",
    cmd = "Dante",
    opts = {
      verbose = true,
      layout = "right",
      presets = presets,
    },

    keys = {
      {
        "<leader>az",
        "<cmd>%Dante grammar<cr>",
        desc = "Dante grammar on %",
        mode = { "n", "v" },
      },
    },

    dependencies = {
      -- This is required
      {
        "S1M0N38/ai.nvim",
        opts = {
          api_key = nil,
          copilot = true,
        },
      },

      -- Not required but really enhances the experience
      {
        "rickhowe/diffchar.vim",
        keys = {

          -- LazyVim use
          -- "[c" and "]"c are user for for goto @class.outer motion
          {
            "[z",
            "<Plug>JumpDiffCharPrevStart",
            desc = "Previous diff",
            silent = true,
          },
          {
            "]z",
            "<Plug>JumpDiffCharNextStart",
            desc = "Next diff",
            silent = true,
          },

          -- Enhance default diff keymaps.
          -- After accepting or rejecting diff, jump to next diff.
          -- default keymaps for acepting and rejecting diff are "do" and "dp".
          {
            "do",
            "<Plug>GetDiffCharPair | <Plug>JumpDiffCharNextStart",
            desc = "Obtain diff and Next diff",
            silent = true,
          },
          {
            "dp",
            "<Plug>PutDiffCharPair | <Plug>JumpDiffCharNextStart",
            desc = "Put diff and Next diff",
            silent = true,
          },
        },
      },
    },
  },
}
