// Fill out your copyright notice in the Description page of Project Settings.


#include "ServerGetBindPort.h"
#include "GenericPlatform/GenericPlatformMisc.h"

// Get Server binded network port
const FString UServerGetBindPort::GetServerBindPort(UObject* WorldContextObject) {
    if (WorldContextObject) {
        if (UWorld* World = WorldContextObject->GetWorld()) {
            return FString::FromInt(World->URL.Port);
        }
        UE_LOG(LogTemp, Warning, TEXT("WorldContextObject->GetWorld() is null"));
    }
    else {
        UE_LOG(LogTemp, Warning, TEXT("WorldContextObject is null"));
    }
    return TEXT("false");
}


FString UServerGetBindPort::GetMechineID()
{
	return FPlatformMisc::GetMachineId().ToString();
}