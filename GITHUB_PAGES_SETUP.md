# GitHub Pages Setup Guide

## Overview

Your repository is now configured with GitHub Pages! This guide will help you enable it and access your documentation site.

## What Was Added

### 1. Jekyll Configuration (`_config.yml`)
- Site title, description, and metadata
- Cayman theme for professional appearance
- SEO plugins and sitemap generation
- Navigation structure

### 2. Landing Page (`index.md`)
- Professional home page with badges
- Quick start guide
- Links to all documentation
- Feature highlights

### 3. GitHub Actions (`.github/workflows/pages.yml`)
- Automatic deployment on push to main
- Jekyll build process
- GitHub Pages deployment

### 4. Dependencies (`Gemfile`)
- Jekyll and required plugins
- GitHub Pages compatibility

## Enabling GitHub Pages

**IMPORTANT**: You need to enable GitHub Pages in your repository settings once.

### Step-by-Step Instructions

1. **Go to Repository Settings**
   ```
   https://github.com/vanhoangkha/aws-mcp-tutorial/settings/pages
   ```

2. **Configure Source**
   - Under "Build and deployment"
   - Source: Select **"GitHub Actions"** (not "Deploy from a branch")

3. **Save Changes**
   - The setting saves automatically when you select GitHub Actions

4. **Wait for Deployment**
   - Go to Actions tab: https://github.com/vanhoangkha/aws-mcp-tutorial/actions
   - You should see "Deploy GitHub Pages" workflow running
   - Wait 2-5 minutes for first deployment
   - Subsequent deployments take 1-2 minutes

5. **Access Your Site**
   ```
   https://vanhoangkha.github.io/aws-mcp-tutorial/
   ```

## Verification Steps

### 1. Check Actions Tab
```bash
# Or visit in browser:
https://github.com/vanhoangkha/aws-mcp-tutorial/actions
```

You should see:
- ✅ "Deploy GitHub Pages" workflow
- ✅ Green checkmark (success)
- ⏱️ Yellow circle (running)
- ❌ Red X (failed - check logs)

### 2. Test the Site

Once deployed, visit:
```
https://vanhoangkha.github.io/aws-mcp-tutorial/
```

Expected pages:
- **Home**: Professional landing page
- **Quick Start**: `/QUICKSTART`
- **Blog**: `/blog`
- **FAQ**: `/FAQ`
- **Comparison**: `/MCP-SERVERS-COMPARISON`
- **Examples**: `/examples/`

### 3. Check Navigation

All internal links should work:
- ✅ Quick Start button
- ✅ Examples links
- ✅ FAQ link
- ✅ Comparison guide
- ✅ GitHub repository link

## Troubleshooting

### Issue: 404 Not Found

**Cause**: GitHub Pages not enabled or still deploying

**Solution**:
1. Check repository settings (step 1-3 above)
2. Verify Actions workflow completed successfully
3. Wait 5 minutes and refresh
4. Clear browser cache

### Issue: Workflow Failed

**Cause**: Build error or permissions issue

**Solution**:
1. Check Actions logs:
   ```
   https://github.com/vanhoangkha/aws-mcp-tutorial/actions
   ```
2. Click on failed workflow
3. Review error messages
4. Common fixes:
   - Ensure "Read and write permissions" in Settings → Actions → General
   - Check Jekyll syntax in `_config.yml`
   - Verify all markdown files have valid frontmatter

### Issue: Broken Links

**Cause**: Incorrect baseurl or file paths

**Solution**:
- All internal links use relative paths
- No need for baseurl in links
- Example: Use `/QUICKSTART` not `/aws-mcp-tutorial/QUICKSTART`

### Issue: Theme Not Applied

**Cause**: Jekyll build issue or theme not loading

**Solution**:
1. Check Actions workflow logs
2. Verify `_config.yml` has:
   ```yaml
   theme: jekyll-theme-cayman
   ```
3. Clear browser cache
4. Wait for complete deployment

## Customization

### Changing Theme

Edit `_config.yml`:
```yaml
# Available GitHub-supported themes:
theme: jekyll-theme-cayman       # Current (recommended)
# theme: jekyll-theme-minimal
# theme: jekyll-theme-architect
# theme: jekyll-theme-slate
```

See all themes: https://pages.github.com/themes/

### Adding Google Analytics

Edit `_config.yml`:
```yaml
google_analytics: UA-XXXXXXXX-X  # Your tracking ID
```

### Custom Domain

1. Add CNAME file:
   ```bash
   echo "docs.yourdomain.com" > CNAME
   git add CNAME
   git commit -m "Add custom domain"
   git push
   ```

2. Configure DNS:
   - Add CNAME record: `docs` → `vanhoangkha.github.io`

3. Update repository settings:
   - Settings → Pages → Custom domain
   - Enter: `docs.yourdomain.com`
   - Enable HTTPS

## Automatic Updates

**Your site auto-deploys on every push to main!**

Workflow:
```
1. You push to main
   ↓
2. GitHub Actions triggers
   ↓
3. Jekyll builds site
   ↓
4. Deploys to GitHub Pages
   ↓
5. Site updated (1-2 minutes)
```

## SEO Features

Included plugins:
- **jekyll-seo-tag**: Meta tags, Open Graph, Twitter Cards
- **jekyll-sitemap**: XML sitemap for search engines
- **jekyll-feed**: RSS feed for blog posts

Your site will be indexed by:
- ✅ Google
- ✅ Bing
- ✅ DuckDuckGo
- ✅ Other search engines

## Performance

Expected metrics:
- **Build time**: 30-60 seconds
- **Deploy time**: 60-120 seconds
- **Page load**: <1 second
- **Lighthouse score**: 95-100

## Monitoring

### Check Deployment Status

```bash
# Via GitHub CLI
gh run list --workflow=pages.yml

# Via browser
https://github.com/vanhoangkha/aws-mcp-tutorial/actions/workflows/pages.yml
```

### View Logs

```bash
# Latest run
gh run view --log

# Specific run
gh run view RUN_ID --log
```

## Best Practices

1. **Always test locally before pushing**
   ```bash
   # Install Jekyll (optional)
   bundle install
   bundle exec jekyll serve
   # Visit: http://localhost:4000/aws-mcp-tutorial/
   ```

2. **Use descriptive commit messages**
   - Triggers are logged with commit message
   - Helps track what changed

3. **Check Actions after push**
   - Verify successful deployment
   - Review for any warnings

4. **Update documentation regularly**
   - Keep content fresh
   - Fix broken links
   - Update examples

## Additional Resources

- [GitHub Pages Documentation](https://docs.github.com/en/pages)
- [Jekyll Documentation](https://jekyllrb.com/docs/)
- [GitHub Actions for Pages](https://github.com/actions/deploy-pages)
- [Supported Themes](https://pages.github.com/themes/)

## Support

If you encounter issues:
1. Check Actions logs
2. Review this troubleshooting guide
3. Search [GitHub Community](https://github.community/)
4. [Create an issue](https://github.com/vanhoangkha/aws-mcp-tutorial/issues)

---

**Your documentation site is ready!** 🚀

Visit: **https://vanhoangkha.github.io/aws-mcp-tutorial/**

*Remember to enable GitHub Pages in repository settings (step 1-3 above)*
