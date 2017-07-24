drop table if exists `wn_antonym`;
create table `wn_antonym` (
  `synset_id_1` decimal(10,0) default NULL,
  `wnum_1` decimal(10,0) default NULL,
  `synset_id_2` decimal(10,0) default NULL,
  `wnum_2` decimal(10,0) default NULL
);
create index `wn_antonym_synset_id_1` on `wn_antonym` (`synset_id_1`);
create index `wn_antonym_synset_id_2` on `wn_antonym` (`synset_id_2`);
create index `wn_antonym_wnum_1` on `wn_antonym` (`wnum_1`);
create index `wn_antonym_wnum_2` on `wn_antonym` (`wnum_2`);

drop table if exists `wn_attr_adj_noun`;
create table `wn_attr_adj_noun` (
  `synset_id_1` decimal(10,0) default NULL,
  `synset_id_2` decimal(10,0) default NULL
);
create index `wn_attr_adj_noun_synset_id_1` on `wn_attr_adj_noun` (`synset_id_1`);
create index `wn_attr_adj_noun_synset_id_2` on `wn_attr_adj_noun` (`synset_id_2`);

drop table if exists `wn_cause`;
create table `wn_cause` (
  `synset_id_1` decimal(10,0) default NULL,
  `synset_id_2` decimal(10,0) default NULL
);
create index `wn_cause_synset_id_1` on `wn_cause` (`synset_id_1`);
create index `wn_cause_synset_id_2` on `wn_cause` (`synset_id_2`);

drop table if exists `wn_class_member`;
create table `wn_class_member` (
  `synset_id_1` decimal(10,0) default NULL,
  `synset_id_2` decimal(10,0) default NULL,
  `class_type` char(2) default NULL
);
create index `wn_class_member_synset_id_1` on `wn_class_member` (`synset_id_1`);
create index `wn_class_member_synset_id_2` on `wn_class_member` (`synset_id_2`);

drop table if exists `wn_derived`;
create table `wn_derived` (
  `synset_id_1` decimal(10,0) default NULL,
  `wnum_1` decimal(10,0) default NULL,
  `synset_id_2` decimal(10,0) default NULL,
  `wnum_2` decimal(10,0) default NULL
);
create index `wn_derived_synset_id_1` on `wn_derived` (`synset_id_1`);
create index `wn_derived_synset_id_2` on `wn_derived` (`synset_id_2`);
create index `wn_derived_wnum_1` on `wn_derived` (`wnum_1`);
create index `wn_derived_wnum_2` on `wn_derived` (`wnum_2`);

drop table if exists `wn_entails`;
create table `wn_entails` (
  `synset_id_1` decimal(10,0) default NULL,
  `synset_id_2` decimal(10,0) default NULL
);
create index `wn_entails_synset_id_1` on `wn_entails` (`synset_id_1`);
create index `wn_entails_synset_id_2` on `wn_entails` (`synset_id_2`);

drop table if exists `wn_gloss`;
CREATE TABLE `wn_gloss` (
  `synset_id` decimal(10,0) NOT NULL default '0',
  `gloss` varchar(255) default NULL,
  PRIMARY KEY  (`synset_id`)
  
);

drop table if exists `wn_hypernym`;
create table `wn_hypernym` (
  `synset_id_1` decimal(10,0) default NULL,
  `synset_id_2` decimal(10,0) default NULL
);
create index `wn_hypernym_synset_id_1` on `wn_hypernym` (`synset_id_1`);
create index `wn_hypernym_synset_id_2` on `wn_hypernym` (`synset_id_2`);

drop table if exists `wn_hyponym`;
create table `wn_hyponym` (
  `synset_id_1` decimal(10,0) default NULL,
  `synset_id_2` decimal(10,0) default NULL
);
create index `wn_hyponym_synset_id_1` on `wn_hyponym` (`synset_id_1`);
create index `wn_hyponym_synset_id_2` on `wn_hyponym` (`synset_id_2`);

drop table if exists `wn_mbr_meronym`;
create table `wn_mbr_meronym` (
  `synset_id_1` decimal(10,0) default NULL,
  `synset_id_2` decimal(10,0) default NULL
);
create index `wn_mbr_meronym_synset_id_1` on `wn_mbr_meronym` (`synset_id_1`);
create index `wn_mbr_meronym_synset_id_2` on `wn_mbr_meronym` (`synset_id_2`);

drop table if exists `wn_part_meronym`;
create table `wn_part_meronym` (
  `synset_id_1` decimal(10,0) default NULL,
  `synset_id_2` decimal(10,0) default NULL
);
create index `wn_part_meronym_synset_id_1` on `wn_part_meronym` (`synset_id_1`);
create index `wn_part_meronym_synset_id_2` on `wn_part_meronym` (`synset_id_2`);

drop table if exists `wn_participle`;
create table `wn_participle` (
  `synset_id_1` decimal(10,0) default NULL,
  `wnum_1` decimal(10,0) default NULL,
  `synset_id_2` decimal(10,0) default NULL,
  `wnum_2` decimal(10,0) default NULL
);
create index `wn_participle_synset_id_1` on `wn_participle` (`synset_id_1`);
create index `wn_participle_synset_id_2` on `wn_participle` (`synset_id_2`);
create index `wn_participle_wnum_1` on `wn_participle` (`wnum_1`);
create index `wn_participle_wnum_2` on `wn_participle` (`wnum_2`);

drop table if exists `wn_pertainym`;
create table `wn_pertainym` (
  `synset_id_1` decimal(10,0) default NULL,
  `wnum_1` decimal(10,0) default NULL,
  `synset_id_2` decimal(10,0) default NULL,
  `wnum_2` decimal(10,0) default NULL
);
create index `wn_pertainym_synset_id_1` on `wn_pertainym` (`synset_id_1`);
create index `wn_pertainym_synset_id_2` on `wn_pertainym` (`synset_id_2`);
create index `wn_pertainym_wnum_1` on `wn_pertainym` (`wnum_1`);
create index `wn_pertainym_wnum_2` on `wn_pertainym` (`wnum_2`);

drop table if exists `wn_see_also`;
create table `wn_see_also` (
  `synset_id_1` decimal(10,0) default NULL,
  `wnum_1` decimal(10,0) default NULL,
  `synset_id_2` decimal(10,0) default NULL,
  `wnum_2` decimal(10,0) default NULL
);
create index `wn_see_also_synset_id_1` on `wn_see_also` (`synset_id_1`);
create index `wn_see_also_synset_id_2` on `wn_see_also` (`synset_id_2`);
create index `wn_see_also_wnum_1` on `wn_see_also` (`wnum_1`);
create index `wn_see_also_wnum_2` on `wn_see_also` (`wnum_2`);

drop table if exists `wn_similar`;
create table `wn_similar` (
  `synset_id_1` decimal(10,0) default NULL,
  `synset_id_2` decimal(10,0) default NULL
);
create index `wn_similar_synset_id_1` on `wn_similar` (`synset_id_1`);
create index `wn_similar_synset_id_2` on `wn_similar` (`synset_id_2`);

drop table if exists `wn_subst_meronym`;
create table `wn_subst_meronym` (
  `synset_id_1` decimal(10,0) default NULL,
  `synset_id_2` decimal(10,0) default NULL
);
create index `wn_subst_meronym_synset_id_1` on `wn_subst_meronym` (`synset_id_1`);
create index `wn_subst_meronym_synset_id_2` on `wn_subst_meronym` (`synset_id_2`);

drop table if exists `wn_synset`;
create table `wn_synset` (
  `synset_id` decimal(10,0) NOT NULL default '0',
  `w_num` decimal(10,0) NOT NULL default '0',
  `word` varchar(50) default NULL,
  `ss_type` char(2) default NULL,
  `sense_number` decimal(10,0) NOT NULL default '0',
  `tag_count` decimal(10,0) default NULL,
  PRIMARY KEY  (`synset_id`,`w_num`)
);
create index `synset_id` on `wn_synset` (`synset_id`);
create index `w_num` on `wn_synset` (`w_num`);
create index `word` on `wn_synset` (`word`);

drop table if exists `wn_verb_frame`;
create table `wn_verb_frame` (
  `synset_id_1` decimal(10,0) default NULL,
  `f_num` decimal(10,0) default NULL,
  `w_num` decimal(10,0) default NULL
);
create index `wn_verb_frame_synset_id_1` on `wn_verb_frame` (`synset_id_1`);
create index `wn_verb_frame_f_num` on `wn_verb_frame` (`f_num`);
create index `wn_verb_frame_w_num` on `wn_verb_frame` (`w_num`);

drop table if exists `wn_verb_group`;
create table `wn_verb_group` (
  `synset_id_1` decimal(10,0) default NULL,
  `synset_id_2` decimal(10,0) default NULL
);
create index `wn_verb_group_synset_id_1` on `wn_verb_group` (`synset_id_1`);
create index `wn_verb_group_synset_id_2` on `wn_verb_group` (`synset_id_2`);

