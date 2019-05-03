package br.com.lab360.oneinternacional.ui.fragments.geofence;

import android.Manifest;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.pm.PackageManager;
import android.graphics.Color;
import android.os.Bundle;
import androidx.core.app.ActivityCompat;
import androidx.fragment.app.Fragment;
import androidx.fragment.app.FragmentTransaction;
import android.text.format.DateUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.google.android.gms.maps.CameraUpdateFactory;
import com.google.android.gms.maps.GoogleMap;
import com.google.android.gms.maps.OnMapReadyCallback;
import com.google.android.gms.maps.SupportMapFragment;
import com.google.android.gms.maps.model.CameraPosition;
import com.google.android.gms.maps.model.CircleOptions;
import com.google.android.gms.maps.model.LatLng;
import com.google.android.gms.maps.model.Marker;
import com.google.android.gms.maps.model.MarkerOptions;
import com.google.gson.Gson;

import java.util.Arrays;
import java.util.List;

import br.com.lab360.oneinternacional.R;
import br.com.lab360.oneinternacional.application.AdaliveApplication;
import br.com.lab360.oneinternacional.logic.model.pojo.geofence.GeofenceItem;
import br.com.lab360.oneinternacional.utils.SharedPrefsHelper;
import butterknife.ButterKnife;
import lib.location.GPSTracker;

public class GeofenceMapFragment extends Fragment {
    protected SupportMapFragment mapFragment;
    protected GoogleMap map;
    private static final long GEOFENCE_EXPIRATION_IN_HOURS = 12;
    public static final long GEOFENCE_EXPIRATION_IN_MILLISECONDS = GEOFENCE_EXPIRATION_IN_HOURS * DateUtils.HOUR_IN_MILLIS;

    private BroadcastReceiver receiver = new BroadcastReceiver() {

        @Override
        public void onReceive(Context context, Intent intent) {

            Bundle bundle = intent.getExtras();
            if (bundle != null) {
                int resultCode = bundle.getInt("done");
                if (resultCode == 1) {
                    Double latitude = bundle.getDouble("latitude");
                    Double longitude = bundle.getDouble("longitude");

                    //updateMarker(latitude, longitude);
                }
            }

        }
    };

    @Override
    public void onCreate(Bundle savedInstanceState) {
        setRetainInstance(true);
        setHasOptionsMenu(true);

        super.onCreate(savedInstanceState);
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.fragment_geofence_map, container, false);
        ButterKnife.bind(this, view);

        mapFragment = SupportMapFragment.newInstance();
        FragmentTransaction fragmentTransaction = getChildFragmentManager().beginTransaction();
        fragmentTransaction.add(R.id.map_container, mapFragment);
        fragmentTransaction.commit();

        return view;
    }

    @Override
    public void onPause() {
        super.onPause();
        getActivity().unregisterReceiver(receiver);
    }

    @Override
    public void onResume() {
        super.onResume();
        if (mapFragment != null) {
            mapFragment.getMapAsync(new OnMapReadyCallback() {

                @Override
                public void onMapReady(GoogleMap googleMap) {
                    map = googleMap;
                    setMyLocation(map);
                    displayGeofences();
                }
            });
        }

        getActivity().registerReceiver(receiver,
                new IntentFilter("com.lab30.base.geolocation.service"));

    }

    public void setMyLocation(GoogleMap googleMap) {
        if (ActivityCompat.checkSelfPermission(getContext(), Manifest.permission.ACCESS_FINE_LOCATION) != PackageManager.PERMISSION_GRANTED && ActivityCompat.checkSelfPermission(getContext(), Manifest.permission.ACCESS_COARSE_LOCATION) != PackageManager.PERMISSION_GRANTED) {
            return;
        }

        googleMap.setMyLocationEnabled(true);
    }

    protected void displayGeofences() {
        Gson gson = new Gson();
        SharedPrefsHelper sharedPrefsHelper = AdaliveApplication.getInstance().getSharedPrefsHelper();
        List<GeofenceItem> regionResponse = Arrays.asList(gson.fromJson(sharedPrefsHelper.get("GEOFENCE", ""), GeofenceItem[].class));

        for (GeofenceItem region : regionResponse) {
            if(!region.getId().equals("0")){
                CircleOptions circleOptions1 = new CircleOptions()
                        .center(new LatLng(region.getLatitude(), region.getLongitude()))
                        .radius(region.getRadius()).strokeColor(Color.RED)
                        .strokeWidth(2).fillColor(Color.argb(30, 255, 0, 0));
                map.addCircle(circleOptions1);

                GPSTracker tracker = new GPSTracker(getContext());
                CameraPosition cameraPosition = new CameraPosition.Builder()
                        .target(new LatLng(tracker.getLatitude(), tracker.getLongitude()))
                        .zoom(17)
                        .build();

                map.animateCamera(CameraUpdateFactory.newCameraPosition(cameraPosition));

                LatLng location = new LatLng(region.getLatitude(),region.getLongitude());
                Marker marker = map.addMarker(new MarkerOptions().position(location).title(String.valueOf(region.getId())).snippet("Longitude: "+ region.getLatitude()+ " "+ "Latitude: " + region.getLongitude()));
                marker.showInfoWindow();
            }
        }
    }

    /*
    protected void createMarker(Double latitude, Double longitude) {
        LatLng currentLocation = new LatLng(latitude, longitude);
        CameraUpdate cameraUpdate = CameraUpdateFactory.newLatLngZoom(currentLocation , 16);
        myPositionMarker = map.addMarker(new MarkerOptions().position(currentLocation));
        map.moveCamera(CameraUpdateFactory.newLatLng(currentLocation ));
        map.animateCamera(cameraUpdate);
    }

    protected void updateMarker(Double latitude, Double longitude) {
        if (myPositionMarker == null) {
            createMarker(latitude, longitude);
        }

        LatLng latLng = new LatLng(latitude, longitude);
        myPositionMarker.setPosition(latLng);
        map.moveCamera(CameraUpdateFactory.newLatLng(latLng));
    }

    @Override
    public void onCreateOptionsMenu(Menu menu, MenuInflater inflater) {
        super.onCreateOptionsMenu(menu, inflater);

        inflater.inflate(R.menu.menu_map, menu);
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        switch (item.getItemId()) {
            case R.id.events:
                Fragment f = new EventsFragment();

                getFragmentManager().beginTransaction()
                        .replace(android.R.id.content, f).addToBackStack("events")
                        .commit();
                return true;
        }
        return super.onOptionsItemSelected(item);
    }
*/
}
