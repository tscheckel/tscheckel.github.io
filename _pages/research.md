---
layout: archive
title: "Research"
permalink: /research/
author_profile: true
redirect_from:
  - /research
---

I am interested in Bayesian econometric methods. My current research examines:
estimation techniques under mis-specified models, covariance modeling and
probabilistic modeling of economic networks.

{% include base_path %}

# Working Papers
{% for post in site.wps reversed %}
  {% include archive-single.html %}
{% endfor %}