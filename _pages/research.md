---
layout: archive
title: "Research"
permalink: /research/
author_profile: true
redirect_from:
  - /research
---

{% include base_path %}

# Working Papers

{% for post in site.publications reversed %}
  {% include archive-single.html %}
{% endfor %}
