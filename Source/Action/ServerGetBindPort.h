// Fill out your copyright notice in the Description page of Project Settings.

#pragma once

#include "CoreMinimal.h"
#include "Kismet/BlueprintFunctionLibrary.h"
#include "ServerGetBindPort.generated.h"

/**
 * 
 */
UCLASS()
class ACTION_API UServerGetBindPort : public UBlueprintFunctionLibrary
{
	GENERATED_BODY()
	UFUNCTION(BlueprintCallable, BlueprintPure, meta = (WorldContext = "WorldContextObject"), Category = "Net")
	static const FString GetServerBindPort(UObject* WorldContextObject);

	UFUNCTION(BlueprintCallable, BlueprintPure, Category = "Util")
	static FString GetMechineID();
};
