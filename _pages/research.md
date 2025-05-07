---
permalink: /
title: "Research"
author_profile: true
redirect_from: 
  - /research/
  - /research.html
---

{% include base_path %}

# Working Papers

{% for post in site.publications reversed %}
  {% include archive-single.html %}
{% endfor %}
