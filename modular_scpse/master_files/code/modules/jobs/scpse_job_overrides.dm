#define SCPSE_JOB_DESCRIPTION_CLASS_D "Survive your assigned testing schedule, obey Foundation personnel, and do not enter restricted zones."
#define SCPSE_JOB_DESCRIPTION_CLASS_E "Containment-restricted personnel assigned to high-risk site labor and observation."
#define SCPSE_JOB_DESCRIPTION_SITE_DIRECTOR "Command the facility, authorize containment priorities, and answer to Foundation oversight."
#define SCPSE_JOB_DESCRIPTION_HR "Manage personnel records, access changes, and staff assignments for the facility."
#define SCPSE_JOB_DESCRIPTION_SECURITY_COMMANDER "Coordinate facility security, breach response, armory policy, and prisoner control."
#define SCPSE_JOB_DESCRIPTION_RESEARCH_DIRECTOR "Supervise anomaly research, approve testing plans, and keep science staff alive."
#define SCPSE_JOB_DESCRIPTION_MAINTENANCE_CHIEF "Keep containment infrastructure powered, sealed, repaired, and documented."
#define SCPSE_JOB_DESCRIPTION_MEDICAL_CHIEF "Lead medical response, quarantine triage, autopsies, and staff fitness for duty."
#define SCPSE_JOB_DESCRIPTION_CONTAINMENT_SUPERVISOR "Oversee containment checkpoints, holding areas, and Class-D movement."
#define SCPSE_JOB_DESCRIPTION_INTERNAL_AFFAIRS "Investigate staff misconduct, evidence handling, and procedural violations."
#define SCPSE_JOB_DESCRIPTION_SECURITY_GUARD "Protect Foundation assets, enforce access control, and respond to containment incidents."
#define SCPSE_JOB_DESCRIPTION_ENGINEER "Maintain power, atmospherics, doors, and containment support systems."
#define SCPSE_JOB_DESCRIPTION_ENVIRONMENTAL "Maintain ventilation, air alarms, scrubbers, and hazardous atmosphere controls."
#define SCPSE_JOB_DESCRIPTION_MEDICAL "Treat injured staff and detainees while respecting containment protocols."
#define SCPSE_JOB_DESCRIPTION_RESPONSE_UNIT "Respond to emergencies across the facility and stabilize casualties under fire."
#define SCPSE_JOB_DESCRIPTION_CHEMIST "Prepare medical compounds, decontamination agents, and authorized research reagents."
#define SCPSE_JOB_DESCRIPTION_RESEARCHER "Run approved tests, document anomalous behavior, and follow containment instructions."
#define SCPSE_JOB_DESCRIPTION_TECH_SPECIALIST "Maintain robotics, AI-adjacent systems, equipment, and technical containment devices."
#define SCPSE_JOB_DESCRIPTION_BIORESEARCHER "Handle genetic analysis, biometrics, cloning systems, and biological anomaly samples."
#define SCPSE_JOB_DESCRIPTION_CORONER "Perform autopsies, identify causes of death, and preserve evidence after incidents."

/datum/job/assistant
	title = "Class-D"
	description = SCPSE_JOB_DESCRIPTION_CLASS_D
	faction = FACTION_FOUNDATION
	supervisors = "Foundation personnel"

/datum/job/prisoner
	title = "Class-E"
	description = SCPSE_JOB_DESCRIPTION_CLASS_E
	faction = FACTION_FOUNDATION
	supervisors = "Containment Supervisor"

/datum/job/captain
	title = "Site Director"
	description = SCPSE_JOB_DESCRIPTION_SITE_DIRECTOR
	faction = FACTION_FOUNDATION
	supervisors = "O5 Council"

/datum/job/head_of_personnel
	title = "HR Liaison"
	description = SCPSE_JOB_DESCRIPTION_HR
	faction = FACTION_FOUNDATION
	supervisors = "Site Director"

/datum/job/head_of_security
	title = "Security Commander"
	description = SCPSE_JOB_DESCRIPTION_SECURITY_COMMANDER
	faction = FACTION_FOUNDATION
	supervisors = "Site Director"

/datum/job/research_director
	title = "Director of Research"
	description = SCPSE_JOB_DESCRIPTION_RESEARCH_DIRECTOR
	faction = FACTION_FOUNDATION
	supervisors = "Site Director"

/datum/job/chief_engineer
	title = "Chief of Maintenance"
	description = SCPSE_JOB_DESCRIPTION_MAINTENANCE_CHIEF
	faction = FACTION_FOUNDATION
	supervisors = "Site Director"

/datum/job/chief_medical_officer
	title = "Chief Medical Officer"
	description = SCPSE_JOB_DESCRIPTION_MEDICAL_CHIEF
	faction = FACTION_FOUNDATION
	supervisors = "Site Director"

/datum/job/warden
	title = "Containment Supervisor"
	description = SCPSE_JOB_DESCRIPTION_CONTAINMENT_SUPERVISOR
	faction = FACTION_FOUNDATION
	supervisors = "Security Commander"

/datum/job/detective
	title = "Internal Affairs"
	description = SCPSE_JOB_DESCRIPTION_INTERNAL_AFFAIRS
	faction = FACTION_FOUNDATION
	supervisors = "Site Director and Security Commander"

/datum/job/security_officer
	title = "Security Guard"
	description = SCPSE_JOB_DESCRIPTION_SECURITY_GUARD
	faction = FACTION_FOUNDATION
	supervisors = "Security Commander"

/datum/job/station_engineer
	title = "Facility Engineer"
	description = SCPSE_JOB_DESCRIPTION_ENGINEER
	faction = FACTION_FOUNDATION
	supervisors = "Chief of Maintenance"

/datum/job/atmospheric_technician
	title = "Environmental Systems Specialist"
	description = SCPSE_JOB_DESCRIPTION_ENVIRONMENTAL
	faction = FACTION_FOUNDATION
	supervisors = "Chief of Maintenance"

/datum/job/medical_doctor
	title = "Medical Staff"
	description = SCPSE_JOB_DESCRIPTION_MEDICAL
	faction = FACTION_FOUNDATION
	supervisors = "Chief Medical Officer"

/datum/job/paramedic
	title = "Emergency Response Unit"
	description = SCPSE_JOB_DESCRIPTION_RESPONSE_UNIT
	faction = FACTION_FOUNDATION
	supervisors = "Chief Medical Officer and Security Commander"

/datum/job/chemist
	title = "Chemist"
	description = SCPSE_JOB_DESCRIPTION_CHEMIST
	faction = FACTION_FOUNDATION
	supervisors = "Chief Medical Officer"

/datum/job/scientist
	title = "Researcher"
	description = SCPSE_JOB_DESCRIPTION_RESEARCHER
	faction = FACTION_FOUNDATION
	supervisors = "Director of Research"

/datum/job/roboticist
	title = "Tech Specialist"
	description = SCPSE_JOB_DESCRIPTION_TECH_SPECIALIST
	faction = FACTION_FOUNDATION
	supervisors = "Director of Research and Chief of Maintenance"

/datum/job/geneticist
	title = "Bio-Researcher"
	description = SCPSE_JOB_DESCRIPTION_BIORESEARCHER
	faction = FACTION_FOUNDATION
	supervisors = "Director of Research"

/datum/job/coroner
	title = "Coroner"
	description = SCPSE_JOB_DESCRIPTION_CORONER
	faction = FACTION_FOUNDATION
	supervisors = "Chief Medical Officer and Internal Affairs"

/datum/outfit/job
	id = /obj/item/card/id/advanced/scpse

/datum/outfit/job/captain
	name = "Site Director"
	id = /obj/item/card/id/advanced/scpse

/datum/outfit/job/hop
	name = "HR Liaison"
	id = /obj/item/card/id/advanced/scpse

/datum/outfit/job/hos
	name = "Security Commander"
	id = /obj/item/card/id/advanced/scpse

/datum/outfit/job/rd
	name = "Director of Research"
	id = /obj/item/card/id/advanced/scpse

/datum/outfit/job/ce
	name = "Chief of Maintenance"
	id = /obj/item/card/id/advanced/scpse

/datum/outfit/job/cmo
	name = "Chief Medical Officer"
	id = /obj/item/card/id/advanced/scpse

/datum/outfit/job/warden
	name = "Containment Supervisor"
	id = /obj/item/card/id/advanced/scpse

/datum/outfit/job/detective
	name = "Internal Affairs"
	id = /obj/item/card/id/advanced/scpse

/datum/outfit/job/security
	name = "Security Guard"
	id = /obj/item/card/id/advanced/scpse

/datum/outfit/job/engineer
	name = "Facility Engineer"
	id = /obj/item/card/id/advanced/scpse

/datum/outfit/job/atmos
	name = "Environmental Systems Specialist"
	id = /obj/item/card/id/advanced/scpse

/datum/outfit/job/doctor
	name = "Medical Staff"
	id = /obj/item/card/id/advanced/scpse

/datum/outfit/job/paramedic
	name = "Emergency Response Unit"
	id = /obj/item/card/id/advanced/scpse

/datum/outfit/job/chemist
	name = "Chemist"
	id = /obj/item/card/id/advanced/scpse

/datum/outfit/job/scientist
	name = "Researcher"
	id = /obj/item/card/id/advanced/scpse

/datum/outfit/job/roboticist
	name = "Tech Specialist"
	id = /obj/item/card/id/advanced/scpse

/datum/outfit/job/geneticist
	name = "Bio-Researcher"
	id = /obj/item/card/id/advanced/scpse

/datum/outfit/job/coroner
	name = "Coroner"
	id = /obj/item/card/id/advanced/scpse

/datum/outfit/job/prisoner
	name = "Class-E"
	id = /obj/item/card/id/advanced/scpse

#undef SCPSE_JOB_DESCRIPTION_CLASS_D
#undef SCPSE_JOB_DESCRIPTION_CLASS_E
#undef SCPSE_JOB_DESCRIPTION_SITE_DIRECTOR
#undef SCPSE_JOB_DESCRIPTION_HR
#undef SCPSE_JOB_DESCRIPTION_SECURITY_COMMANDER
#undef SCPSE_JOB_DESCRIPTION_RESEARCH_DIRECTOR
#undef SCPSE_JOB_DESCRIPTION_MAINTENANCE_CHIEF
#undef SCPSE_JOB_DESCRIPTION_MEDICAL_CHIEF
#undef SCPSE_JOB_DESCRIPTION_CONTAINMENT_SUPERVISOR
#undef SCPSE_JOB_DESCRIPTION_INTERNAL_AFFAIRS
#undef SCPSE_JOB_DESCRIPTION_SECURITY_GUARD
#undef SCPSE_JOB_DESCRIPTION_ENGINEER
#undef SCPSE_JOB_DESCRIPTION_ENVIRONMENTAL
#undef SCPSE_JOB_DESCRIPTION_MEDICAL
#undef SCPSE_JOB_DESCRIPTION_RESPONSE_UNIT
#undef SCPSE_JOB_DESCRIPTION_CHEMIST
#undef SCPSE_JOB_DESCRIPTION_RESEARCHER
#undef SCPSE_JOB_DESCRIPTION_TECH_SPECIALIST
#undef SCPSE_JOB_DESCRIPTION_BIORESEARCHER
#undef SCPSE_JOB_DESCRIPTION_CORONER
