<?php
// $Id: jskitcomments.admin.inc,v 1.7 2010/01/19 08:33:33 rehos Exp $

/**
 * Menu callback; Displays the administration settings for JS-Kit Echo.
 */
function jskitcomments_admin_settings() {
  global $base_url;
  
  $form = array();
  $form['node'] = array(
    '#type' => 'fieldset',
    '#title' => t('Node settings'),
	'#collapsible' => TRUE,
	'#collapsed' => FALSE,
  );
  $form['node']['jskitcomments_languageneutral'] = array(
    '#type' => 'checkbox',
    '#title' => t('Language neutral'),
    '#description' => t('Check this box if you want comments to apply for the source node and translated nodes. Uncheck if you want comments per languange'),
    '#default_value' => variable_get('jskitcomments_languageneutral', 1),
  );
  $form['node']['jskitcomments_nodetypes'] = array(
    '#type' => 'checkboxes',
    '#title' => t('Node Types'),
    '#description' => t('Apply comments only to the selected node types.'),
    '#default_value' => variable_get('jskitcomments_nodetypes', array()),
    '#options' => node_get_types('names'),
  );
  $form['node']['jskitcomments_content_area'] = array(
    '#type' => 'checkbox',
    '#title' => t('Display in content area'),
    '#description' => t('Check this box if you want to display the comments within the content area'),
    '#default_value' => variable_get('jskitcomments_content_area', 1),
  );
  $form['node']['jskitcomments_content_weight'] = array(
    '#type' => 'textfield',
    '#title' => t('Content weight'),
    '#size' => 3,
    '#maxlength' => 3,
    '#description' => t('The content weight controls the position of the JS-Kit Echo widget within the content area'),
    '#default_value' => variable_get('jskitcomments_content_weight', 50),
  ); 
  $form['node']['jskitcomments_link'] = array(
    '#type' => 'checkbox',
    '#title' => t('Display comment count links'),
    '#description' => t('Check this box if you want to display the comment count links with teasers'),
    '#default_value' => variable_get('jskitcomments_link', 1),
  );
  $form['domain'] = array(
    '#type' => 'fieldset',
    '#title' => t('Domain settings'),
	'#collapsible' => TRUE,
	'#collapsed' => FALSE,
  );
  $form['domain']['jskitcomments_domain'] = array(
    '#type' => 'textfield',
    '#title' => t('Domain'),
    '#description' => t('Enter your domain if you want to target a different domain than your website. Otherwise leave it blank.'),
    '#default_value' => variable_get('jskitcomments_domain', ''),
  );
  $form['domain']['jskitcomments_rss'] = array(
    '#type' => 'textfield',
    '#title' => t('RSS'),
    '#description' => t('Enter the url of your JS-Kit Echo RSS feed.'),
    '#default_value' => variable_get('jskitcomments_rss', ''),
  );
  $form['domain']['jskitcomments_rsstitle'] = array(
    '#type' => 'textfield',
    '#title' => t('RSS Title'),
    '#description' => t('Enter the title of your JS-Kit Echo RSS feed.'),
    '#default_value' => variable_get('jskitcomments_rsstitle', t('JS-Kit Echo RSS')),
  );  
  $form['custom'] = array(
    '#type' => 'fieldset',
    '#title' => t('Customization settings'),
	'#collapsible' => TRUE,
	'#collapsed' => TRUE,
  );
  $form['custom']['jskitcomments_label'] = array(
    '#type' => 'textfield',
    '#title' => t('Label'),
    '#description' => t('You can override the default "Leave a comment" message by using entering a label. Otherwise leave it blank.'),
    '#default_value' => variable_get('jskitcomments_label', ''),
  );
  $form['custom']['jskitcomments_paginate'] = array(
    '#type' => 'textfield',
    '#title' => t('Paginate'),
    '#size' => 3,
    '#maxlength' => 3,
    '#description' => t('You can break long lists of comments into multiple pages by specifying the number of comments per page. Otherwise leave it blank.'),
    '#default_value' => variable_get('jskitcomments_paginate', 0),
  ); 
  $form['custom']['jskitcomments_backwards'] = array(
    '#type' => 'checkbox',
    '#title' => t('Backwards'),
    '#description' => t('You can check this box to make the comments on a page appear in reverse chronological order. This attribute also places the comments controls at the top of the comments box.'),
    '#default_value' => variable_get('jskitcomments_backwards', 0),
  );
  $form['custom']['jskitcomments_thread'] = array(
    '#type' => 'checkbox',
    '#title' => t('Thread'),
    '#description' => t('Use this checkbox to turn threading on/off'),
    '#default_value' => variable_get('jskitcomments_thread', 1),
  );
  $form['custom']['jskitcomments_adminbgcolor'] = array(
    '#type' => 'textfield',
    '#title' => t('Admin background color'),
    '#default_value' => variable_get('jskitcomments_adminbgcolor', ''),
    '#size' => 6,
    '#maxlength' => 6,
    '#description' => t('Use this attribute to change the background color of post made by site admin. Allows users to easily recognize site admin.'),
  );
  $form['custom']['jskitcomments_flashcolor'] = array(
    '#type' => 'textfield',
    '#title' => t('Flash color'),
    '#default_value' => variable_get('jskitcomments_flashcolor', ''),
    '#size' => 6,
    '#maxlength' => 6,
    '#description' => t('Use this attribute to override the default flashing background color used to highlight a post that has just been submitted. Default color is yellow.'),
  );
  $form['custom']['notsupported'] = array(
    '#type' => 'fieldset',
    '#title' => t('Not supported by JS-Kit Echo'),
    '#collapsible' => TRUE,
    '#collapsed' => TRUE,
  );
  $form['custom']['notsupported']['jskitcomments_skin'] = array(
    '#type' => 'textfield',
    '#title' => t('Skin'),
    '#description' => t('You can override the default skin by entering the name of the desired skin. Otherwise leave it blank.'),
    '#default_value' => variable_get('jskitcomments_skin', ''),
  );
  $form['custom']['notsupported']['jskitcomments_avatars'] = array(
    '#type' => 'checkbox',
    '#title' => t('Avatars'),
    '#description' => t('Use this checkbox to turn avatars on/off'),
    '#default_value' => variable_get('jskitcomments_avatars', 0),
  );
  
  $form['epb'] = array(
	'#type' => 'fieldset',
	'#title' => t('External Profile Binding (EPB)'),
	'#collapsible' => TRUE,
	'#collapsed' => TRUE,
  );
  $form['epb']['jskitcomments_epb_on'] = array(
	'#type' => 'checkbox',
	'#title' => t('Use External Profile Binding (EPB)'),
	'#description' => t('See the JS-Kit Echo Wiki for more information: ') . l('http://wiki.js-kit.com/External-Profile-Binding','http://wiki.js-kit.com/External-Profile-Binding'),
	'#default_value' => variable_get('jskitcomments_epb_on',0),
  );
  
  $form['epb']['jskitcomments_epb_secret'] = array(
	'#type' => 'textfield',
	'#title' => t('Secret Key'),
	'#description' => t('In order to set up EPB for a site, the publisher and
						JS-Kit need to agree on a secret key (used by JS-Kit to
						ensure EPB-related data was not altered by a third
						party) and the format of the host system user id.'),
	'#default_value' => variable_get('jskitcomments_epb_secret',''),
  );
  
  $form['epb']['jskitcomments_epb_id_format'] = array(
	'#type' => 'textfield',
	'#title' => t('User ID Format'),
	'#description' => t('<p>The user id is a key which identifies the host system\'s user within JS-Kit system (@id will be replaced with unique user identifier - from Drupal or, if defined below, third party cookie.). The id has a form of a URL (as per RFC3986) with the following additional constraints:</p>
	<ul>
    <li>The only allowed schema is "http".</li>
    <li>No upper case letters allowed.</li>
    <li>The URL should end with "/".</li>
	</ul>
	
<p>JS-Kit places user ids of different publishers into the same namespace, so to avoid collisions the user ids are normally derived from the publisher\'s domain name. Here are the examples of valid user ids:</p>

    <ul><li>http://joe.smith.domain.com/</li>
    <li>http://domain.com/user/joe.smith/</li>
  </ul>
<p>JS-Kit needs to know which part of the user id is constant and which may vary
for different users (the latter is joe.smith in the above examples).</p>'),
	'#default_value' => variable_get('jskitcomments_epb_id_format',$base_url . '/@id/'),
  );

  $form['epb']['jskitcomments_epb_url'] = array(
	'#type' => 'textfield',
	'#title' => t('Non-drupal authentication EPB path (advanced and not common)'),
	'#description' => t('Use this option if you would like to define a custom
						php function (a menu hook) to define the values of the user
						profile id and information. Enter the path below. The path
						should be defined by a menu hook in your own custom module
						that sets various properties and returns an EPB json object.
						See the jskitcomments.epb.inc file for an example.'),
	'#default_value' => variable_get('jskitcomments_epb_url','/jskitcomments/epb'),
  );
  return system_settings_form($form);
}
