# -*- coding: utf-8 -*-
<%inherit file="../base.mako"/>

<h1>${ _('Details about package "%s"') % c.package.name }</h1>

<table>
  <tr>
    <th>${ _('Name') }:</th>
    <td>${ c.package.name }</td>
  </tr>

  <tr>
    <th>${ _('Uploader') }:</th>
    <td><a href="${ h.url_for('packages', action='uploader', id=c.package.user.email) }">${ c.package.user.name }</a> &lt;<a href="mailto: ${ c.package.user.email }">${ c.package.user.email }</a>&gt;

% if c.config['debexpo.debian_specific'] == 'true':

    (<a href="http://qa.debian.org/developer.php?login=${ c.package.user.email }">Debian QA page</a>)

% endif

    </td>
  </tr>

  <tr>
    <th>${ _('Description') }:</th>
    <td>${ c.package.description.replace('\n', '<br/>') }</td>
  </tr>

% if 'user_id' in c.session:

  <tr>
    <th>${ _('Subscribe') }:</th>
    <td><a href="${ h.url_for('subscribe', packagename=c.package.name) }">${ _('Edit your subscription') }</a></td>
  </tr>

% endif

% if 'user_id' in c.session and c.session['user_id'] == c.package.user_id:

  <tr>
    <th>${ _('Delete package') }:</th>
    <td>${ h.rails.link_to(_('Delete this package'), h.url_for(action="delete", packagename=c.package.name), confirm=_('Are you sure?')) }</td>
  </tr>

% endif

</table>

<h1>${ _('Package versions') }</h1>

% for package_version in c.package.package_versions:

<fieldset>
  <legend>${ package_version.version }</legend>

  <h2>${ _('Information')}</h2>

  <table>
    <tr>
      <th>${ _('Version') }:</th>
      <td>${ package_version.version }

% if c.config['debexpo.debian_specific'] == 'true' and c.session.get('user_id') == c.package.user_id:

  (<a href="${ h.url_for('rfs', packagename=c.package.name) }">${ _('View RFS template') }</a>)

% endif

      </td>
    </tr>

    <tr>
      <th>${ _('Uploaded') }:</th>
      <td>${ package_version.uploaded }</td>
    </tr>

    <tr>
      <th>${ _('Debian Source Control file URL') }:</th>
      <td>

    % for pkgfile in package_version.source_packages[0].package_files:

        % if pkgfile.filename.endswith('.dsc'):

            <a href="${ c.config['debexpo.server'] }/debian/${ pkgfile.filename }">${ c.config['debexpo.server'] }/debian/${ pkgfile.filename }</a>

        % endif

    % endfor

      </td>
    </tr>

    <tr>
      <th>${ _('Section') }:</th>
      <td>${ package_version.section }</td>
    </tr>

    <tr>
      <th>${ _('Priority') }:</th>
      <td>${ package_version.priority }</td>
    </tr>

% if c.config['debexpo.debian_specific'] == 'true':

    % if package_version.closes is not None:

        % for bug in package_version.closes.split(','):

    <tr>
      <th>${ _('Closes bugs') }:</th>
      <td><a href="http://bugs.debian.org/${ bug }">${ bug }</a></td>
    </tr>

        % endfor

    % endif

% endif
</table>

% if package_version.package_info:
<h2>${ _('QA information')}</h2>

<table>

    ## Print result from plugins
    % for pkginfo in package_version.package_info:
        % if pkginfo.data:
            <tr>
                <th>${ h.constants.PLUGIN_SEVERITY[pkginfo.severity] }:</th>
                <td>${ h.converters.nl2br(pkginfo.data) }</td>
            </tr>
        % endif
    % endfor
</table>
% endif

<h3>Comments</h3>

% if len(package_version.package_comments) > 0:

  <ol>

  % for comment in package_version.package_comments:

    <li>
      <p>
        <pre>${ h.util.html_escape(comment.text) }</pre>

% if comment.outcome == c.constants.PACKAGE_COMMENT_OUTCOME_NEEDS_WORK:

  <span style="color: red;">${ _('Needs work') }</span>

% elif comment.outcome == c.constants.PACKAGE_COMMENT_OUTCOME_PERFECT:

  <span style="color: green;">${ _('Perfect') }</span>

% endif

        <i>${ comment.user.name } at ${ comment.time }</i>

% if comment.status == c.constants.PACKAGE_COMMENT_STATUS_UPLOADED and c.config['debexpo.debian_specific'] == 'true':

  <strong>${ _('Package has been uploaded to Debian') }</strong>

% endif

     </p>
   </li>

  % endfor

  </ol>

% else:

<p><i>${ _('No comments') }</i></p>

% endif

<h3>New comment</h3>

% if 'user_id' in c.session:

${ h.rails.form(h.url_for('comment', packagename=c.package.name)) }
${ h.rails.hidden_field('package_version', package_version.id) }
${ h.rails.text_area('text', size='82x10') }
<br/>

${ h.rails.select('outcome', h.rails.options_for_select(c.outcomes, c.constants.PACKAGE_COMMENT_OUTCOME_UNREVIEWED)) }

% if config['debexpo.debian_specific'] == 'true' and c.user.status == c.constants.USER_STATUS_DEVELOPER:

${ h.rails.check_box('status') } ${ _('Uploaded to Debian') }

% endif

${ h.rails.submit() }
${ h.rails.end_form() }

% endif

</fieldset>

% endfor
