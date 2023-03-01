import os

# Configuration file for the Sphinx documentation builder.
#
# For the full list of built-in configuration values, see the documentation:
# https://www.sphinx-doc.org/en/master/usage/configuration.html

# -- Project information -----------------------------------------------------

project = 'CFS'
copyright = '2023'
author = 'Gennadiy Belonosov'
release = 'v0.2.0'

# -- General configuration ---------------------------------------------------

extensions = [
    'sphinx.ext.autodoc', 
    'sphinxcontrib.matlab', 
    'sphinx.ext.napoleon',
    'myst_parser']

this_dir = os.path.dirname(os.path.abspath(__name__))
matlab_src_dir = os.path.abspath(os.path.join(this_dir, '..'))
primary_domain = 'mat'

source_suffix = {
    '.rst': 'restructuredtext',
    '.md': 'markdown',
}

templates_path = ['_templates']
exclude_patterns = ['_build', 'Thumbs.db', '.DS_Store']
matlab_keep_package_prefix = True

myst_enable_extensions = [
    "tasklist"
]
# -- Options for HTML output -------------------------------------------------
# https://www.sphinx-doc.org/en/master/usage/configuration.html#options-for-html-output

html_theme = 'pydata_sphinx_theme'
html_logo = "_static/logo_round.bmp"
html_static_path = ['_static']

html_css_files = [
      "https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/fontawesome.min.css",
      "https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/solid.min.css",
      "https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/brands.min.css",
]
html_theme_options = {
    # "external_links": [
    #     {
    #         "url": "https://people.socsci.tau.ac.il/mu/mudriklab/",
    #         "name": "Liad Mudrik lab",
    #     },

    #     {
    #         "url": "http://psychtoolbox.org/",
    #         "name": "PTB-3",
    #     },

    # ],

    # "header_links_before_dropdown": 4,
    "icon_links": [
        {
            "name": "GitHub",
            "url": "https://github.com/Mudrik-Lab/CFS",
            "icon":  "fa-brands fa-github",
        },
        {
            "name": "MudrikLab",
            "url": "https://people.socsci.tau.ac.il/mu/mudriklab/",
            "icon": "_static/mudriklab_logo.png",
            "type": "local",
            "attributes": {"target": "_blank"},
        },
    ],
    "logo": {
        "text": "CFS",
        "image": "_static/logo_round.bmp",
        "alt_text": "CFS",
    },
}

# html_context = {
#     "github_user": "Mudrik-Lab",
#     "github_repo": "CFS",
#     "github_version": "main",
#     "doc_path": "docs",
# }
# html_theme_options = {
#   "footer_items": []
# }


