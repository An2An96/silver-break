#define	Police.						Police_

#define CopList_ADD(%0)				Iter_Add(Cop, %0)
#define CopList_REMOVE(%0)			Iter_Remove(Cop, %0)
#define IsPoliceDuty(%0)   			Iter_Contains(Cop, %0)  //  Optimize

enum
{
	//	Легкие (штраф)
	CRIME_NOT_LIGHT,
	CRIME_DRUNK,
	CRIME_NOT_LIC,
	//	Средние (арест)
	CRIME_HOOLIGAN,
	CRIME_ROBBERY_SHOP,
	CRIME_THEFT_AUTO,
	CRIME_CREATE_GUN,
	CRIME_CREATE_DRUGS,
	CRIME_RESIST,
	CRIME_CARRY_CRIMINAL,
	CRIME_HAVE_GUN,
	CRIME_THINGS,
	//	Тяжкие (арест)
	CRIME_KILL,
	CRIME_COP_KILL,
	CRIME_RUNAWAY,
	CRIME_IN_JAIL
}

enum
{
	PS_NONE,
	PS_CHECK,
	PS_WAIT,
	PS_WAIT_ACTION,
	PS_WAIT_OUT_VEH,
	PS_OUT_COMPLETE,
	PS_CRIMINAL,
}