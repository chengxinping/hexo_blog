<script async src="https://dn-lbstatics.qbox.me/busuanzi/2.3/busuanzi.pure.mini.js"></script>
<div class="copyright" >
  {% set current = date(Date.now(), "YYYY") %}

<i class="fa fa-smile-o "></i>鄂ICP备17006614号
  <div class="powered-by"></div>
  &copy; {% if theme.since and theme.since != current %} {{ theme.since }} - {% endif %}
  <span itemprop="copyrightYear">{{ current }}</span>
  <span class="with-love">
    <i class="fa fa-{{ theme.authoricon }}"></i>
  </span>
  <span class="author" itemprop="copyrightHolder">{{ config.author }}</span>
</div>

{% if theme.copyright %}



<i class="fa fa-user-md"></i><span id="busuanzi_container_site_uv">
  访问用户：<span id="busuanzi_value_site_uv"></span>
</span>
<div class="powered-by"></div>

<i class="fa fa-eye"></i><span id="busuanzi_container_site_pv">
    访问量：<span id="busuanzi_value_site_pv"></span>
</span>
<div class="powered-by"></div>
<div class="theme-info">
 <i class="fa fa-flag"></i> <span class="post-count">博客全站共{{ totalcount(site) }}字</span>
</div>


<br/>
<div class="theme-info">
<i class="fa fa-umbrella"></i>
  {{ __('footer.theme') }}
  <a class="theme-link" href="https://github.com/iissnan/hexo-theme-next">
  </a>
</div>
{% endif %}
