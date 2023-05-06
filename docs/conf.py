import os

# Configuration file for the Sphinx documentation builder.
#
# For the full list of built-in configuration values, see the documentation:
# https://www.sphinx-doc.org/en/master/usage/configuration.html

# -- Project information -----------------------------------------------------

project = 'CFSVM'
copyright = '2023, Liad Mudrik lab'
author = 'Gennadiy Belonosov'
release = 'v0.4.0'

# -- General configuration ---------------------------------------------------

extensions = [
    'sphinx.ext.autodoc', 
    'sphinxcontrib.matlab', 
    'sphinx.ext.napoleon',
    'myst_parser']


myst_heading_anchors = 5

this_dir = os.path.dirname(os.path.abspath(__name__))
matlab_src_dir = os.path.abspath(os.path.join(this_dir, '..'))
primary_domain = 'mat'
autodoc_member_order='groupwise'
# matlab_src_dir=r"C:\Users\Gennadiy\Documents\Gennadiy\Masking-CFS\CFSVM"
matlab_short_links = True
matlab_show_property_default_value = True
source_suffix = {
    '.rst': 'restructuredtext',
    '.md': 'markdown',
}

templates_path = ['_templates']
exclude_patterns = ['_build', 'Thumbs.db', '.DS_Store']
matlab_keep_package_prefix = True

myst_enable_extensions = [
    "tasklist",
    "dollarmath"
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
        "text": "CFSVM",
        "image": "_static/logo_round.bmp",
        "alt_text": "Continuous flash suppression & Visual masking",
    },
    "footer_start": ['copyright'],
    "footer_end": [],
}

