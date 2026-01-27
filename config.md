<!--
    FRANKLIN CONFIGURATION FILE
    ===========================
    This file sets global variables for your site.
    Variables defined here are accessible in all pages via {{variable_name}}.
    
    Franklin uses a mix of:
    - Markdown for content
    - HTML templates in _layout/
    - Julia code blocks for dynamic content
-->

<!-- BASIC SITE INFO -->
@def website_title = "Your Name"
@def website_descr = "Academic Homepage"
@def website_url   = "https://tscheckel.github.io/tscheckel-franklin/"

<!-- For local preview, prepath="" works. For GitHub project pages, set to repo name -->
@def prepath = "tscheckel-franklin"

<!-- AUTHOR INFO (use in templates via {{author}}) -->
@def author = "Your Name"

<!-- 
    NAVIGATION 
    Define menu items as a list of (name, url) tuples.
    Access in templates with {{menu}} 
-->
@def menu = [("Home", "/"), ("Research", "/research/"), ("Publications", "/publications/"), ("CV", "/cv/")]

<!--
    PAGE DEFAULTS
    These can be overridden per-page by redefining them at the top of any .md file
-->
@def mintoclevel = 2
@def maxtoclevel = 3
@def hasmath = false
@def hascode = false

<!--
    DATE FORMAT
    Used by Franklin's {{fd_mtime}} and similar date functions
-->
@def date_format = "U d, yyyy"

<!--
    RSS SETTINGS (optional, for blog/news feeds)
-->
@def generate_rss = false
@def rss_website_title = "Your Name - Academic Homepage"
@def rss_website_descr = "Updates from my academic website"
