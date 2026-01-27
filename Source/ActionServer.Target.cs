// Fill out your copyright notice in the Description page of Project Settings.

using UnrealBuildTool;
using System.Collections.Generic;

public class ActionServerTarget : TargetRules
{
	public ActionServerTarget(TargetInfo Target) : base(Target)
	{
		Type = TargetType.Server;
#if UE_5_4_OR_LATER
        DefaultBuildSettings = BuildSettingsVersion.V4;
        IncludeOrderVersion = EngineIncludeOrderVersion.Latest;
#else
        DefaultBuildSettings = BuildSettingsVersion.V2;
#endif

		ExtraModuleNames.AddRange( new string[] { "Action" } );
	}
}
