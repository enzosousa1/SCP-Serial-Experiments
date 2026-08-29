// SCP Foundation branding for CentCom Emergency Response Teams: treat templates as distinct MTF units.

/datum/team/ert
	name = "Mobile Task Force"

/// Default ghost poll wording for subtypes that do not define polldesc.
/datum/ert/New()
	if (!polldesc)
		polldesc = "a Code [code] SCP Foundation Mobile Task Force response element"

// --- Standard tiers (Epsilon-11 is the ubiquitous internal-security MTF.) ---

/datum/ert
	rename_team = "MTF Epsilon-11 (Nine-Tailed Fox)"

/datum/ert/blue
	rename_team = "MTF Epsilon-11 (Nine-Tailed Fox)"
	polldesc = "a Code Blue MTF Epsilon-11 containment support detail"

/datum/ert/amber
	rename_team = "MTF Epsilon-11 (Nine-Tailed Fox)"
	polldesc = "a Code Amber MTF Epsilon-11 rapid containment team"

/datum/ert/red
	rename_team = "MTF Alpha-1 (Red Right Hand)"
	polldesc = "a Code Red MTF Alpha-1 council-direct action element"

// --- Heavy / specialty templates ---

/datum/ert/deathsquad
	rename_team = "MTF Nu-7 (Hammer Down)"
	mission = "Asset denial and threat termination. Preserve operational secrecy."
	polldesc = "an MTF Nu-7 liquidation and containment breach response"

/datum/ert/marine
	rename_team = "MTF Nu-7 Amphibious Platoon"
	polldesc = "an MTF Nu-7 combat engineering and strike detail"

/datum/ert/centcom_official
	rename_team = "Foundation Oversight"
	polldesc = "an Oversight Directorate field inspector"

/datum/ert/centcom_official/New()
	mission = "Conduct a routine performance review of Site [station_name()] and its Director."

/datum/ert/inquisition
	rename_team = "MTF Psi-8 (Exorcists)"
	mission = "Eliminate active thaumaturgic, occult, and Class-E reality contamination aboard the Site."
	polldesc = "an MTF Psi-8 doctrinal counter-anomaly team"

/datum/ert/janitor
	rename_team = "MTF Eta-11 (Sanitation)"
	mission = "Restore the Site to acceptable biological and chemical containment standards."
	polldesc = "an MTF Eta-11 hazardous cleanup and decontamination squad"

/datum/ert/intern
	rename_team = "Provisional Field Interns"
	mission = "Assist on-site personnel under direct supervision. Do not improvise."
	polldesc = "a Foundation provisional internship deployment (hazard waiver required)"

/datum/ert/intern/unarmed
	rename_team = "Provisional Field Interns (Disarmed)"

/datum/ert/erp
	rename_team = "MTF Gamma-999 (Mandatory Morale)"
	mission = "Deliver ethics-approved morale support and crew stress relief under protocol Rainbow."
	polldesc = "a Code Rainbow Ethics Committee morale tasking"

/datum/ert/bounty_hunters
	rename_team = "MTF Sigma-66 (Contract Recovery)"
	mission = "Apprehend or neutralize designated persons of interest as briefed."
	polldesc = "deniable Foundation recovery contractors under MTF Sigma-66 charter"

/datum/ert/militia
	rename_team = "Auxiliary Security Volunteers"
	mission = "Support Foundation assets until formal relief arrives."
	polldesc = "an irregular auxiliary force responding under Site mutual-aid protocol"

/datum/ert/medical
	rename_team = "MTF Omicron-4 (Field Medevac)"
	mission = "Triage casualties, stabilize restrained anomalies where ordered, evacuate priorities."
	polldesc = "an MTF Omicron-4 emergency medical insertion team"

// --- Base antagonist datum ---

/datum/antagonist/ert
	name = "Mobile Task Force Operative"
	suicide_cry = "FOR THE FOUNDATION!!"

/datum/antagonist/ert/greet()
	if(!ert_team)
		return

	to_chat(owner, "<span class='warningplain'><B><font size=3 color=red>You are the [name].</font></B></span>")

	var/missiondesc = "<span class='warningplain'>Your Mobile Task Force team is deploying to [station_name()] under containment command authority.</span>"
	if(leader)
		missiondesc += "<span class='warningplain'> You are designated team command: coordinate the insertion and ensure mission success. Depart when your squad is ready.</span>"
	else
		missiondesc += "<span class='warningplain'> Follow lawful orders from your team lead and maintain chain of custody for any anomalies encountered.</span>"
	if(!rip_and_tear)
		missiondesc += "<span class='warningplain'> Minimize casualties among non-hostile personnel and compliant civilians where consistent with containment.</span>"

	missiondesc += "<span class='warningplain'><BR><B>Mission briefing</B>: [ert_team.mission.explanation_text]</span>"
	to_chat(owner, missiondesc)

/datum/antagonist/ert/security
	role = "Containment Specialist"

/datum/antagonist/ert/engineer
	role = "Technical Specialist"

/datum/antagonist/ert/medic
	role = "Medical Specialist"

/datum/antagonist/ert/commander
	role = "Field Commander"

/datum/antagonist/ert/janitor
	role = "Decontamination Specialist"

/datum/antagonist/ert/janitor/heavy
	role = "Lead Sanitation Specialist"

/datum/antagonist/ert/clown
	role = "Morale Technician"

/datum/antagonist/ert/official
	name = "Oversight Inspector"
	role = "Inspector"

/datum/antagonist/ert/official/greet()
	. = ..()
	if (ert_team)
		to_chat(owner, "<span class='warningplain'>The Oversight Directorate is dispatching you to Site [station_name()] with assignment: [ert_team.mission.explanation_text]</span>")
	else
		to_chat(owner, "<span class='warningplain'>The Oversight Directorate is dispatching you to Site [station_name()] with assignment: [mission.explanation_text]</span>")

/datum/antagonist/ert/official/forge_objectives()
	if (ert_team)
		return ..()
	if(mission)
		return
	var/datum/objective/missionobj = new ()
	missionobj.owner = owner
	missionobj.explanation_text = "Conduct a routine performance review of Site [station_name()] and its Director."
	missionobj.completed = TRUE
	mission = missionobj
	objectives |= mission

/datum/antagonist/ert/deathsquad
	name = "Nu-7 Operative"

/datum/antagonist/ert/deathsquad/leader
	name = "Nu-7 Strike Commander"

/datum/antagonist/ert/marine
	name = "Nu-7 Amphibious Commander"

/datum/antagonist/ert/marine/security
	name = "Nu-7 Heavy Weapons Specialist"

/datum/antagonist/ert/marine/engineer
	name = "Nu-7 Combat Engineer"

/datum/antagonist/ert/marine/medic
	name = "Nu-7 Combat Medic"

/datum/antagonist/ert/militia
	name = "Auxiliary Volunteer"

/datum/antagonist/ert/militia/general
	name = "Auxiliary Sergeant-Major"

/datum/antagonist/ert/medical_commander
	role = "Medical Team Lead"

/datum/antagonist/ert/medical_technician
	role = "Casualty Specialist"

/datum/antagonist/ert/intern
	name = "Foundation Intern"

/datum/antagonist/ert/intern/leader
	name = "Senior Foundation Intern"

/datum/antagonist/ert/intern/unarmed
	name = "Foundation Intern"

/datum/antagonist/ert/chaplain
	role = "Doctrinal Specialist"

/datum/antagonist/ert/janitor/party
	role = "Festival Custodian"

/datum/antagonist/ert/security/party
	role = "Crowd Control Specialist"

/datum/antagonist/ert/engineer/party
	role = "Stage Engineer"

/datum/antagonist/ert/clown/party
	role = "Festive Consultant"

/datum/antagonist/ert/commander/party
	role = "Morale Liaison Commander"
